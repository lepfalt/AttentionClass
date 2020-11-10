class UsersController < ApplicationController
  before_action :restrict_by_authorization, only: %i[update destroy]
  before_action :authorized, only: [:show]
  before_action :set_user , only: %i[destroy update_password]
  before_action :load_enviroments_vars, only: %i[reset_password]

  # GET /users/1
  # GET /users/1.json
  def show
    @responses_user = Response.all.where(user_id: params[:id])
    @user = User.find(params[:id])
  end

  # GET /users/new
  def new
    return if redirected_logged

    @user = User.new
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_to_be_created)

    error = @user.validate_user?

    if error.nil? && @user.save
      handler_notice('Usuário cadastrado com sucesso!', login_path)
    else
      handler_notice_error(error, new_user_path)
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    puts 'ENTROU NO UPDATE USER'
    return vinculate_user unless params[:vincular].nil?

    update_password
  end

  def vinculate_user
    puts 'PARAMS ', params
    registered_user = User.find_by(email: params.dig(:user, :email))

    class_id = session[:class_id_vinculate]
    puts 'CLASSGH ', session[:class_id_vinculate]
    
    if registered_user.nil?
      handler_notice_error('Usuário inexistente.', new_user_class_path(class_id))
    elsif registered_user.admin?
      handler_notice_error('Este usuário não pode ser vinculado à turma devido ao tipo de perfil que possui.', new_user_class_path(class_id))
    else
      class_associate = registered_user.class_groups.find_by(id: class_id)

      if class_associate.nil?
        associate_user(registered_user, class_id)
      else
        handler_notice_error('Este usuário já está vinculado à turma.', new_user_class_path(class_id))
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    remove_user_associations
    @user.destroy
    session[:user_id] = nil
    redirect_to login_path
  end

  def reset_password
    return unless valid_token?

    # Armazenando para reacessar página em caso de erro
    session[:token] = params[:reset]
    session[:expire] = params[:expire]
    @user = match_user(params[:reset])
  end

  def update_password
    return unless valid_password?(reset_params)

    @user.password_digest = encrypt(params.dig(:user, :password))
    if @user.save
      handler_notice('Senha resetada com sucesso!', login_path)
    else
      puts 'Erro ao resetar senha', @user.errors
      redirect_to_reset_password
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def user_params
    params.require(:user).permit(:email, :password)
  end

  def reset_params
    params.require(:user).permit(:password, :password_confirm)
  end

  def valid_password?(params_validate)
    if params_validate[:password].present?
      flash[:noticeError] = 'As senhas devem ser iguais.' if params_validate[:password] != params_validate[:password_confirm]
    else
      flash[:noticeError] = 'A senha deve ser preenchida.'
    end

    return true if flash[:noticeError].nil?
    redirect_to_reset_password
    false
  end

  def user_to_be_created
    {
      name: params.dig(:user, :name),
      registration: params.dig(:user, :registration),
      profile: params.dig(:user, :profile),
      email: params.dig(:user, :email),
      password: params.dig(:user, :password),
      password_confirm: params.dig(:user, :password_confirm),
      password_digest: BCrypt::Password.create(params.dig(:user, :password))
    }.to_hash
  end

  def associate_user(user, class_id)
    class_group = ClassGroup.find_by(id: class_id)
    user.class_groups << class_group

    assign_group_tasks(class_group, user.id)

    handler_notice('Usuário vinculado com sucesso.', class_group_path(class_id))
  end

  def remove_user_associations
    if @user.admin?
      classes = ClassGroup.where(user_id: @user.id)
      classes.each do |cgroup|
        cgroup.tasks.each do |task|
          task.responses.destroy_all
          task.destroy
        end

        cgroup.users.clear
        cgroup.destroy
      end
    else
      @user.responses.destroy_all
      @user.class_groups.clear
    end
  end

  def assign_group_tasks(group, user_id)
    group.tasks.each do |task|
      if task.progress?
        response = Response.new(user_id: user_id, task_id: task.id, status: 0, active: true)
        puts "Error na criacao de response: ", response.errors unless response.save
      end
    end
  end

  def match_user(token)
    token_compare = BCrypt::Password.new(token)
    User.all.each do |user|
      sentence_compare = user.name + ENV["SEED"] + user.profile

      if token_compare == sentence_compare
        return user
      end
    end

    nil
  end

  def valid_token?
    expire = params[:expire].to_i
    intervalo = Time.now.to_i - expire
    return true if intervalo / 60 <= 10 # não resetar se tiver mais de 10 min que foi gerado o token

    flash[:noticeError] = "token expirado"
    false
  end

  def redirect_to_reset_password
    redirect_to reset_password_path(@user, :expire => session[:expire], :reset => session[:token])
  end

  def encrypt(sentence)
    #colocar exception
    BCrypt::Password.create(sentence)
  end
end
