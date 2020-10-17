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
