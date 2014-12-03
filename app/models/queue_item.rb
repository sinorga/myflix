class QueueItem < ActiveRecord::Base
  belongs_to :user
  belongs_to :video

  default_scope { order(:position) }
  before_validation :assign_position

  validates_uniqueness_of :video_id, scope: [:user_id]
  #validates_uniqueness_of :position, scope: [:video_id, :user_id]
  validates_presence_of :user_id, :video_id


  delegate :category, to: :video
  delegate :title, to: :video, prefix: :video


  def rating
    review = Review.find_by(user_id: user.id, video_id: video.id)
    review.rating if review
  end

  def category_name
    video.category.name
  end

  protected
  def assign_position
    unless position
      self.position = 1 + (last_position || 0)
    end
  end

  def last_position
    if user_id && !QueueItem.where(user_id: user_id).empty?
      QueueItem.where(user_id: user_id).last.position
    else
      0
    end
  end
end
