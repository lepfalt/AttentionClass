class UsersController < ApplicationController
  before_action :authorized, only: [:show]
  before_action :set_user , only: [:destroy]
  # GET /users
  # GET /users.json
  def index
    @user = User.all
    # puts 'Entrou no index, ' params.require(:user).permit(:id)
    # @responses_user = Response.where(user_id: session[:id])
  end

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

  # GET /users/1/edit
  def edit; end

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
        
        flash[:notice] = 'Usuário vinculado com sucesso.'
      else
        flash[:notice] = 'Este usuário já está vinculado à turma.'
      end
      redirect_to class_group_path(class_id)
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

  def find_responses
    Response.where(user_id: @user.id)
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
        puts 'REMOVEU RESPONSES E TASKS'
        cgroup.users.clear
        cgroup.destroy
      end
      puts 'REMOVEU USERS E TURMA'
    else
      @user.responses.destroy_all
      puts 'REMOVEU RESPONSES'
      @user.class_groups.clear
      puts 'REMOVEU TURMA2'
    end
  end
end
