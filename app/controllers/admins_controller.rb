class AdminsController < ApplicationController
  before_action :require_user
  before_action :require_admin

  def require_admin
    unless current_user.admin?
      redirect_to home_path, danger: "You can't access this area."
    end
  end
end
