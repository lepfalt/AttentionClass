class SessionsController < ApplicationController
  def new
    puts 'login: ', params[:email], params[:password]
  end

  def create
    @user = User.find_by(email: params[:email])
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      if @user.admin?
        redirect_to tasks_path
      else
        redirect_to responses_path
      end
    else
      redirect_to login_path
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to login_path
  end
end
