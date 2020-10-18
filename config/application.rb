# frozen_string_literal: true

require_relative 'boot'

require 'rails/all'

Bundler.require(*Rails.groups)

module Attentionclass
  class Application < Rails::Application
    config.load_defaults 6.0

    # Versão de seus ativos, mude isso se quiser expirar todos os seus ativos
    config.assets.version = '1.0'

    # Lendo vars de ambiente
    config.before_configuration do
      env_file = File.join(Rails.root, 'config', 'local_env.yml')
      if File.exist?(env_file)
        YAML.safe_load(File.open(env_file)).each do |key, value|
          ENV[key.to_s] = value
        end
      end
    end

    config.action_mailer.delivery_method = :smtp
    config.action_mailer.smtp_settings = {
      address: 'smtp.gmail.com',
      port: 587,
      domain: 'smtp.gmail.com',
      user: 'Attention Class',
      user_name: ENV['USERNAME_EMAIL'],
      password: ENV['PASSWORD_EMAIL'],
      authentication: :login,
      enable_starttls_auto: true
    }
    # Para debug apenas, é melhor que a linha abaixo seja adicionado apenas no ambiente de desenvolvimento
    config.action_mailer.raise_delivery_errors = true
    config.action_mailer.default_url_options = { host: 'localhost:3000' }

    config.time_zone = 'Brasilia'
    config.active_record.default_timezone = :local
  end
end
