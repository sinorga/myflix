module VideosHelper
  def show_average_rating(video)
    video.average_rating.round(1)
  end

  def show_current_user_rating(video)
    review = video.reviews.find_by(user_id: current_user.id)
    review ? review.rating : "-"
  end
end
