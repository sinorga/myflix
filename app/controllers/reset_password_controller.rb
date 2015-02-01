class ResetPasswordController < ApplicationController
  before_action :not_signed_in
  before_action :find_user_by_vaild_token

  def edit
    redirect_to invalid_token_path unless @user
  end

  def update
    if @user
      if @user.update(password: params[:password])
        @user.clear_password_reset_token
        flash[:success] = "Update password success"
        redirect_to sign_in_path
      else
        flash.now[:danger] = "Password can't be blank"
        render :edit
      end
    else
      redirect_to invalid_token_path
    end
  end

  protected
  def find_user_by_vaild_token
    @user = User.find_by(password_reset_token: params[:id])
  end

end
