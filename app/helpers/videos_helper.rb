module VideosHelper
  def show_average_rating(video)
    video.average_rating.round(1)
  end
end
