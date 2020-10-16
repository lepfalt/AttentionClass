class UsersController < ApplicationController
  before_action :authorized, only: [:show]
  before_action :set_user , only: %i[destroy update_password]

  # GET /users/1
  # GET /users/1.json
  def show
    @responses_user = Response.all.where(user_id: params[:id])
    @user = User.find(params[:id])
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_to_be_created)

    if validate_user? && @user.save
      flash[:notice] = 'Usuário cadastrado com sucesso!'
      redirect_to login_path
    else
      redirect_to new_user_path
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    puts 'ENTRA NO UPDATE'
    email = params[:email]
    class_id = params[:class_id]
    registered_user = User.find_by(email: email)
    
    if registered_user.nil?
      flash[:notice] = 'Usuário inexistente.'
      redirect_to new_user_class_path(class_id)
    elsif registered_user.admin?
      flash[:notice] = 'Este usuário não pode ser vinculado à turma devido ao tipo de perfil que possui.'
      redirect_to new_user_class_path(class_id)
    else
      class_associate = registered_user.class_groups.find_by(id: class_id)

      if class_associate.nil?
        class_group = ClassGroup.find_by(id: class_id)
        registered_user.class_groups << class_group

        assign_group_tasks(class_group, registered_user.id)
        
        flash[:notice] = 'Usuário vinculado com sucesso.'
        redirect_to class_group_path(class_id)
      else
        flash[:notice] = 'Este usuário já está vinculado à turma.'
        redirect_to new_user_class_path(class_id)
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
    puts 'PARAMS ', params
    session[:token] = params[:reset]
    @user = match_user(params[:reset])
  end

  def update_password
    form_params = params.require(:user).permit(:password, :password_confirm)

    unless form_params[:password] == form_params[:password_confirm]
      flash[:notice] = 'As senhas devem ser iguais.'
      redirect_to reset_password_path(@user, :reset => session[:token])
      return
    end
    
    @user.password_digest = BCrypt::Password.create(params.dig(:user, :password))
    if @user.save
      flash[:notice] = 'Senha resetada com sucesso!'
      redirect_to login_path
    else
      puts 'Erro ao resetar senha', @user.errors
      redirect_to reset_password_path(@user, :reset => session[:token])
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

  def validate_user?
    if !@user.valid? 
      flash[:notice] = 'Dados de usuário inválidos.'
    elsif !User.unique_email?(@user.email)
      flash[:notice] = 'Esse email já existe.'
    elsif !@user.confirm_password?(params.dig(:user, :password_confirm)) 
      flash[:notice] = 'A senha precisa ser igual à sua confirmação.'
    else
      return true
    end

    false
  end

  def user_to_be_created
    {
      name: params.dig(:user, :name),
      registration: params.dig(:user, :registration),
      profile: params.dig(:user, :profile),
      email: params.dig(:user, :email),
      password: params.dig(:user, :password),
      password_digest: BCrypt::Password.create(params.dig(:user, :password))
    }.to_hash
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
    envs_vars
    token_compare = BCrypt::Password.new(token)
    User.all.each do |user|
      sentence_compare = user.name + ENV["SEED"] + user.profile

      if token_compare == sentence_compare
        return user
      end
    end

    nil
  end

  def envs_vars
    env_file = File.join(Rails.root, 'config', 'local_env.yml')
    YAML.load(File.open(env_file)).each do |key, value|
      ENV[key.to_s] = value
    end if File.exists?(env_file)
  end
end
