class SessionsController < ApplicationController
  def new
    redirect_to home_path if current_user
  end

  def create
    user = User.find_by(email: params[:email])
    if user and user.authenticate(params[:password])
      if user.active?
        session[:user_id] = user.id
        redirect_to home_path, success: "You are signed in, enjoy!"
      else
        redirect_to sign_in_path, danger: "Your account is locked."
      end
    else
      redirect_to sign_in_path, danger: "Invaild email or password."
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path, success: "You are signed out."
  end
end
