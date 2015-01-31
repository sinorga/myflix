class UsersController < ApplicationController
  before_action :require_user, only: [:show]
  before_action :not_signed_in, only: [:edit_password, :reset_password]
  before_action :find_user_by_vaild_token, only: [:edit_password, :reset_password]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      UserMailer.welcome(@user).deliver
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

  def edit_password
    redirect_to invalid_token_path unless @user
  end

  def reset_password
    if @user
      if @user.update(password: params[:user][:password])
        @user.clear_password_reset_token
        flash[:success] = "Update password success"
        redirect_to sign_in_path
      else
        flash.now[:danger] = "Update password failed"
        render :edit_password
      end
    else
      redirect_to invalid_token_path
    end
  end

  protected
  def user_params
    params.require(:user).permit(:email, :password, :full_name)
  end

  def find_user_by_vaild_token
    @user = User.find_by(password_reset_token: params[:password_reset_token])
  end
end
