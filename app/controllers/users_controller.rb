class UsersController < ApplicationController
  before_action :require_user, only: [:show]
  before_action :not_signed_in, only: [:new, :create]
  before_action :set_invitation_datas, only: [:new, :create]

  def new
    @user = User.new(email: @invitation.try(:email))
    @invite_token = @invitation.try(:token)
    redirect_to invalid_token_path if is_token_invalid?
  end

  def create
    begin
      create_paid_user
    rescue StripeWrapper::CardError => e
      flash[:danger] = e.message
      render :new
    rescue
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

  def is_token_invalid?
    params[:invite_token].present? && !@inviter
  end

  def set_invitation_datas
    if params[:invite_token].present?
      @invitation = Invitation.find_by(token: params[:invite_token])
      @inviter = @invitation.try(:inviter)
    end
  end

  def build_relationship_with_inviter
    if @inviter
      @user.follow(@inviter)
      @inviter.follow(@user)
      @invitation.expire
    end
  end

  def create_paid_user
    User.transaction(requires_new: true) do
      @user = User.new(user_params)
      @user.save!
      stripe_payment!
      UserMailer.delay.welcome(@user)
      build_relationship_with_inviter
      redirect_to sign_in_path
    end
  end

  def stripe_payment!
    token = params[:stripeToken]

    charge = StripeWrapper::Charge.create(
      :amount => 999, # amount in cents, again
      :source => token,
      :description => "payment of #{@user.email}"
    )
  end
end
