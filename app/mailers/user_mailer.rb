class UserMailer < ActionMailer::Base
  default from: "info@myfilx.com"
  def welcome(user)
    @user = user
    mail to: user.email, subject: "Welcome! mylifx"
  end

  def password_reset_notify(user)
    @user = user
    mail to: user.email, subject: "mylifx reset password"
  end

  def send_invitation(invite_user)
    @invite_user = invite_user
    mail to: invite_user.email, subject: "mylifx, #{invite_user.inviter.full_name} invite you!"
  end
end
