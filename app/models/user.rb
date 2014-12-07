class User < ActiveRecord::Base
  has_many :reviews
  has_many :queue_items
  validates_presence_of :email, :password, :full_name
  validates_uniqueness_of :email
  has_secure_password validations: false

  def normalize_queue_items
    queue_items.each_with_index do |queue_item, index|
      queue_item.update(position: index+1)
    end
  end

  def update_review(video, rating)
    review = reviews.find_by(video_id: video.id)
    if review
      review.update!(rating: rating)
    elsif rating.to_s != ''
      review = reviews.build(video: video, rating: rating)
      review.skip_content = true
      review.save!
    end
  end
end
