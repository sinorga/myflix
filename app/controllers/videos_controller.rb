class VideosController < ApplicationController
  before_action :require_user

  def show
    @video = Video.find(params[:id]).decorate
    @reviews = @video.reviews
    @new_review = Review.new
  end

  def search
    @videos = Video.search_by_title(params[:search_term]).decorate
  end
end
