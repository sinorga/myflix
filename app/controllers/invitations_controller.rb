class InvitationsController < ApplicationController
  before_action :require_user

  def new
    @invitation = Invitation.new
  end

  def create
    @invitation = current_user.invitations.build(invitation_params)
    if @invitation.save
      UserMailer.send_invitation(@invitation).deliver
      flash[:success] = "You invited user #{@invitation.name}"
      redirect_to home_path
    else
      flash.now[:danger] = "Invalid input"
      render :new
    end
  end

  protected
  def invitation_params
    params.require(:invitation).permit(:name, :email, :message)
  end
end
