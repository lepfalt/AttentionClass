class SessionsController < ApplicationController
  def new
    # @user = User.new
  end

  def create
    @user = User.find_by(email: params[:email])
    if @user&.authenticate(params[:password])
      session[:user_id] = @user.id
      if @user.admin?
        redirect_to tasks_path
      else
        redirect_to responses_path
      end
    else
      flash[:notice] = 'Usuário inexistente'
      redirect_to login_path
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to login_path
  end
end
