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
    @user = User.new(user_params)
    if @user.valid?
      @user.save
      redirect_to @user
    else
      redirect_to :new
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
end
