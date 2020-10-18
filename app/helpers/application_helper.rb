# frozen_string_literal: true

module ApplicationHelper
  def class_name(class_name)
    current_page?(login_path) || current_page?(root_path) ? '' : class_name
  end

  def main_class
    current_page?(login_path) || current_page?(root_path) ? 'main-content-login' : 'main-content'
  end
end
