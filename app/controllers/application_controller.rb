# frozen_string_literal: true

class ApplicationController < ActionController::Base
  helper_method :logged_in?, :current_user

  def current_user
    @user = User.find(session[:user_id]) if session[:user_id]
  end

  def logged_in?
    !!current_user
  end

  def authorized
    redirect_to login_path unless logged_in?
  end

  private

  def restrict_by_authorization
    return if logged_in? # Se ta logado, redireciona pra conta

    handler_notice_error('É preciso estar logado para acesso das páginas.', login_path)
  end

  def restrict_by_profile_admin
    return unless logged_in? # Se ta logado, redireciona pra conta

    is_admin = User.find_by(id: current_user).admin?
    handler_notice_error('Essa página não existe para este tipo de perfil.', responses_board_path(current_user)) unless is_admin
  end

  def restrict_by_identification(id, path)
    return unless logged_in?

    handler_notice_error('Página não autorizada para a conta logada.', path) unless current_user.id == id
  end

  def redirected_logged
    if logged_in? # Se ta logado, redireciona pra conta
      is_admin = User.find_by(id: current_user).admin?
      if is_admin
        redirect_to tasks_board_path(current_user)
      else
        redirect_to responses_board_path(current_user)
      end

      return true
    end

    false
  end

  def load_enviroments_vars
    env_file = Rails.root.join('config/local_env.yml')
    return unless File.exist?(env_file)

    YAML.safe_load(File.open(env_file)).each do |key, value|
      ENV[key.to_s] = value
    end
  end

  def handler_notice(notice, path)
    flash[:notice] = notice
    redirect_to path
  end

  def handler_notice_error(notice, path)
    flash[:noticeError] = notice
    redirect_to path
  end
end
