class SessionsController < ApplicationController
  def new
    if logged_in? #Se tá logado, redireciona pra conta
      is_admin = User.find_by(id: current_user).admin?
      if is_admin
        redirect_to tasks_board_path(current_user)
      else
        redirect_to responses_board_path(current_user)
      end
    end
  end

  def create
    if is_reset?
      send_email
    else
      @user = User.find_by(email: params[:email])
      if @user&.authenticate(params[:password])
        session[:user_id] = @user.id
        if @user.admin?
          redirect_to tasks_board_path(@user.id)
        else
          redirect_to responses_board_path(@user.id)
        end
      else
        if @user.nil?
          flash[:notice_error] = 'Email ou senha inválidos.'
        else
          flash[:notice_error] = 'Senha Inválida.'
        end

        redirect_to login_path
      end
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to login_path
  end

  def is_reset?
    params[:reset].present?
  end

  def send_email
    if params[:email].present?
      user = User.find_by(email: params[:email])
      if !user.nil?
        UserMailer.with(user: user).confirmation.deliver_later
        flash[:notice] = 'Em instantes você receberá um email para resetar sua senha :).'
      else
        flash[:notice_error] = 'Email inválido.'
      end
    else
      flash[:notice_error] = 'Email precisa ser preenchido.'
    end

    redirect_to login_path
  end

end
