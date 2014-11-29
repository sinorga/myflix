class ReviewsController < ApplicationController
  before_action :require_user
  def create
    @video = Video.find(params[:video_id])
    review = @video.reviews.build(review_params)
    if review.save
      redirect_to video_path(@video)
    else
      @reviews = @video.reviews.reload
      @new_review = Review.new
      render template: 'videos/show'
    end
  end

  private
  def review_params
    params.require(:review).permit(:rating, :content).merge(user_id: current_user.id)
  end
end
