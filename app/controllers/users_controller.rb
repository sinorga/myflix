class UsersController < ApplicationController
  before_action :require_user, only: [:show]
  before_action :not_signed_in, only: [:new, :create]

  def new
    if params[:invite_token].present?
      new_with_invitation
    else
      @user = User.new
    end
  end

  def create
    @user = User.new(user_params)
    result = UserRegistrator.new(@user).register(params[:stripeToken], params[:invite_token])

    if result.success?
      flash[:success] = "Thanks for your registration, please sign in now."
      redirect_to sign_in_path
    elsif result.card_error?
      flash[:danger] = result.message
      render :new
    else
      flash.delete(:danger)
      render :new
    end
  end

  def show
    @user = User.find(params[:id])
    @queue_items = @user.queue_items
    @reviews = @user.reviews
  end

  protected
  def user_params
    params.require(:user).permit(:email, :password, :full_name)
  end

  def new_with_invitation
    invitation = Invitation.find_by(token: params[:invite_token])
    if invitation
      @user = User.new(email: invitation.email)
      @invite_token = invitation.token
    else
      redirect_to invalid_token_path
    end
  end
end
