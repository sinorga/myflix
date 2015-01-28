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
end
