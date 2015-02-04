class UsersController < ApplicationController
  before_action :require_user, only: [:show]
  before_action :not_signed_in, only: [:new, :create]
  before_action :set_invite_datas, only: [:new, :create]

  def new
    @user = User.new
    if params[:invite_token] && !@inviter
      redirect_to invalid_invite_token_path
    end
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

  def set_invite_datas
    @invite_user = InviteUser.find_by(token: params[:invite_token])
    @inviter = @invite_user.try(:inviter)
  end

  def build_relationship_with_inviter
    if @inviter
      @user.follow(@inviter)
      @inviter.follow(@user)
      @invite_user.destroy
    end
  end
end
