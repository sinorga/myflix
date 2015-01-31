class ForgotPasswordController < ApplicationController
  before_action :not_signed_in

  def confirm
    user = User.find_by(email: params[:email])
    if user
      user.generate_password_reset_token
      UserMailer.password_reset_notify(user).deliver
    else
      flash.now[:danger] = "Input email does not exist"
      render :new
    end
  end
end
