class FolloweesController < ApplicationController
  before_action :require_user, only: [:index]
  def index
    @followees = current_user.followees
  end
end
