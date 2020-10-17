class User < ApplicationRecord
  has_many :responses
  has_and_belongs_to_many :class_groups
  has_secure_password

  attr_accessor :password, :password_confirm

  enum profile: { standard: 0, admin: 1 }
  #validates :profile, inclusion: { in: [standard, admin] }

  VALID_EMAIL_FORMAT = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i.freeze
  # pesquisar solução depois
  #validates :email, presence: true, length: {maximum: 260}, format: { with: VALID_EMAIL_FORMAT}, uniqueness: {case_sensitive: false}
  validates :password_digest, :profile, :name, :email, presence: true

  def confirm_password?(confirm)
    @password.eql?(confirm)
  end

  def self.unique_email?(email)
    user = User.find_by(email: email)

    return true if user.nil?

    false
  end

  def validate_user?
    if !self.valid? || !@password.present?
      return 'Dados de usuário inválidos.'
    elsif !User.unique_email?(self.email)
      return 'Esse email já existe.'
    elsif !self.confirm_password?(self.password_confirm) 
      return 'A senha precisa ser igual à sua confirmação.'
    end

    nil
  end
end
