class UsersController < ApplicationController
  before_action :authorized, only: [:show]
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
    puts "USER: ", @user.to_json
    if @user.valid? && @user.confirm_password?(params.dig(:user, :password_confirm)) && @user.unique_email?
      puts 'ENTROU'
      @user.save
      flash[:notice] = 'Usuário cadastrado com sucesso!'
      redirect_to login_path
    else
      flash[:notice] = 'Erros: ' << @user.errors.first.to_s
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
    else
      class_group = ClassGroup.find_by(id: class_id)
      registered_user.class_groups << class_group
      
      flash[:notice] = 'Usuário vinculado com sucesso.'
      redirect_to class_group_path(class_id)
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
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
end
