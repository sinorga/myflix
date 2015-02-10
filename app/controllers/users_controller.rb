class UsersController < ApplicationController
  before_action :require_user, only: [:show]
  before_action :not_signed_in, only: [:new, :create]
  before_action :set_invitation_datas, only: [:new, :create]

  def new
    @user = User.new(email: @invite_user.try(:email))
    @invite_token = @invite_user.try(:token)
    redirect_to invalid_token_path if is_token_invalid?
  end

  def create
    @user = User.new(user_params)

    if @user.save
      UserMailer.welcome(@user).deliver
      build_relationship_with_inviter
      redirect_to sign_in_path
    else
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
      @invite_user = InviteUser.find_by(token: params[:invite_token])
      @inviter = @invite_user.try(:inviter)
    end
  end

  def build_relationship_with_inviter
    if @inviter
      @user.follow(@inviter)
      @inviter.follow(@user)
      @invite_user.expire
    end
  end
end
