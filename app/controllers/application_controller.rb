class ApplicationController < ActionController::Base
  add_flash_types :success, :danger
  protect_from_forgery

  def require_user
    redirect_to sign_in_path unless current_user
  end

  def current_user
    User.find_by_id(session[:user_id]) if session[:user_id]
  end

  def not_signed_in
    redirect_to home_path if current_user
  end

  helper_method :current_user
end
