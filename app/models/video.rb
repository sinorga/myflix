class Video < ActiveRecord::Base
  belongs_to :category
  has_many :reviews, -> { order('created_at desc') }
  mount_uploader :large_cover, VideoLargeCoverUploader
  mount_uploader :small_cover, VideoSmallCoverUploader
  validates_presence_of :title, :description, :large_cover, :small_cover, :stream_url

  def self.search_by_title(title)
    return [] if title.blank?
    where("title LIKE ?", "%#{title}%").order(created_at: :desc)
  end

  def recent_reviews
    reviews.first(10)
  end

  def average_rating
    reviews.empty? ? 0 : (reviews.map(&:rating).map(&:to_f).reduce(:+) / reviews.count)
  end
end
