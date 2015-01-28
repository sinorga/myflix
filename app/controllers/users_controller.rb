class UsersController < ApplicationController
  before_action :require_user, only: [:show]
  before_action :not_signed_in, only: [:forgot_password, :confirm_password_reset, :new_reset_password, :reset_password]

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

  def confirm_password_reset
    user = User.find_by(email: params[:email])
    if user
      user.generate_password_reset_token
      UserMailer.password_reset_notify(user).deliver
    else
      flash[:danger] = "Input email does not exist"
      render :forgot_password
    end
  end

  def new_reset_password
    find_user_by_vaild_token!
  end

  def reset_password
    find_user_by_vaild_token!
    if @user.update(password: params[:password])
      @user.clear_password_reset_token
      redirect_to sign_in_path
    else
      render :new_reset_password
    end
  end

  protected
  def user_params
    params.require(:user).permit(:email, :password, :full_name)
  end

  def not_signed_in
    redirect_to home_path if current_user
  end

  def find_user_by_vaild_token!
    @user = User.find_by(password_reset_token: params[:token])
    raise ActionController::RoutingError.new('Not Found') if !params[:token] || !@user
  end
end
