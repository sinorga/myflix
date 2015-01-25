class UserMailer < ActionMailer::Base
  default from: "info@myfilx.com"
  def welcome(user)
    @user = user
    mail to: user.email, subject: "Welcome! mylifx"
  end
end
