class FolloweesController < ApplicationController
  before_action :require_user, only: [:index, :destroy]
  def index
    @followees = current_user.followees
  end

  def destroy
    followee = current_user.followees.find_by(id: params[:id])
    followee.destroy if followee
    redirect_to people_path
  end
end
