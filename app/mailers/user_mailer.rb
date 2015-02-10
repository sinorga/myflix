class UserMailer < ActionMailer::Base
  default from: "info@myfilx.com"
  def welcome(user)
    @user = user
    mail to: send_to(user), subject: "Welcome! mylifx"
  end

  def password_reset_notify(user)
    @user = user
    mail to: send_to(user), subject: "mylifx reset password"
  end

  def send_invitation(invitation)
    @invitation = invitation
    mail to: send_to(invitation), subject: "mylifx, #{invitation.inviter.full_name} invite you!"
  end

  protected
  def send_to(target)
    Rails.env.staging? ? ENV['STAGING_EMAIL'] : target.email
  end
end
