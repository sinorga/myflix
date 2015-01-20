class FolloweesController < ApplicationController
  before_action :require_user
  def index
    @followees = current_user.followees
  end

  def destroy
    followee = current_user.followees.find_by_id(params[:id])
    current_user.followees.delete(followee) if followee
    redirect_to people_path
  end

  def create
    followee = User.find_by(id: params[:followee_id])
    if followee
      Followership.create(follower: current_user, followee: followee)
    end
    redirect_to people_path
  end

end
