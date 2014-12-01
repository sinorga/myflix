class QueueItem < ActiveRecord::Base
  belongs_to :user
  belongs_to :video
  validates_uniqueness_of :position

  delegate :category, to: :video
  delegate :title, to: :video, prefix: :video


  def rating
    review = Review.find_by(user_id: user.id, video_id: video.id)
    review.rating if review
  end

  def category_name
    video.category.name
  end
end
