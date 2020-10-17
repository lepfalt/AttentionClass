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
    unless logged_in? #Se tá logado, redireciona pra conta
      handler_notice_error('É preciso estar logado para acesso das páginas.', login_path)
    end
  end

  def restrict_by_profile_admin
    if logged_in? #Se tá logado, redireciona pra conta
      is_admin = User.find_by(id: current_user).admin?

      unless is_admin
        handler_notice_error('Essa página não existe para este tipo de perfil.', responses_board_path(current_user))
      end
    end
  end

  def redirected_logged
    if logged_in? #Se tá logado, redireciona pra conta
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
    env_file = File.join(Rails.root, 'config', 'local_env.yml')
    YAML.load(File.open(env_file)).each do |key, value|
      ENV[key.to_s] = value
    end if File.exists?(env_file)
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
