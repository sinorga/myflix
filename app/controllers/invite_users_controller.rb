class InviteUsersController < ApplicationController
  before_action :require_user

  def new
    @invite_user = InviteUser.new
  end

  def create
    @invite_user = current_user.invite_users.build(invite_user_params)
    if @invite_user.save
      UserMailer.send_invitation(@invite_user).deliver
      redirect_to home_path
    else
      flash.now[:danger] = "Invalid input"
      render :new
    end
  end

  protected
  def invite_user_params
    params.require(:invite_user).permit(:name, :email, :message)
  end
end
