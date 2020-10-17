class SessionsController < ApplicationController
  before_action :load_enviroments_vars, only: %i[send_email]

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
        allow_user(@user)
      else
        deny_user(user)
      end
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to login_path
  end

  def send_email
    if params[:email].present?
      user = User.find_by(email: params[:email])
      if !user.nil? 
        trigger_email_to(user)
      else
        handler_notice('Email inválido.', login_path)      
      end
    else
      handler_notice('Email precisa ser preenchido.', login_path)
    end
  end

  private

  def is_reset?
    params[:reset].present?
  end

  def allow_user(user)
    session[:user_id] = user.id
    if user.admin?
      redirect_to tasks_board_path(user.id)
    else
      redirect_to responses_board_path(user.id)
    end
  end

  def deny_user(user)
    if user.nil?
      flash[:notice_error] = 'Email ou senha inválidos.'
    else
      flash[:notice_error] = 'Senha Inválida.'
    end

    redirect_to login_path
  end

  def trigger_email_to(user)
    UserMailer.with(user: user, token: generate_token(user)).confirmation.deliver_later
    handler_notice('Em instantes você receberá um email para resetar sua senha :)', login_path)
  end

  def generate_token(user)
    sentence = user.name + ENV["SEED"] + user.profile
    BCrypt::Password.create(sentence)
  end  
end
