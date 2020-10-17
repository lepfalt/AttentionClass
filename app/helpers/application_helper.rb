module ApplicationHelper

  def get_class_name(class_name)
    current_page?(login_path) ? "" : class_name
  end

  def get_main_class()
    current_page?(login_path) ? "main-content-login" : "main-content"
  end
end
