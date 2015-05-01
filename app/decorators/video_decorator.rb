class VideoDecorator < Draper::Decorator
  delegate_all

  def show_rating
    average_rating ? "#{show_average_rating}/5.0" : "N/A"
  end

  private
  def show_average_rating
    average_rating.round(1)
  end
end
