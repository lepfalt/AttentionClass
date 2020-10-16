class UserMailer < ApplicationMailer
  default :from => 'attentionclasss@gmail.com'
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.confirmation.subject
  #
  def confirmation
    @user = params[:user]
    @token = params[:token]

    mail to: @user.email, subject: "Reset de senha"
  end
end
