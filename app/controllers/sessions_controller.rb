class SessionsController < ApplicationController
  def new
    redirect_to home_path if current_user
  end

  def create
    user = User.find_by(email: params[:email])
    if user and user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to home_path, flash: {success: "You are signed in, enjoy!"}
    else
      flash[:danger] = "Invaild email or password."
      redirect_to sign_in_path
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path, flash: {success: "You are signed out."}
  end
end
