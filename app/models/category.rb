class Category < ActiveRecord::Base
  has_many :videos, -> { order(created_at: :desc) }

  validates :name, uniqueness: true

  def recent_videos
    videos.first(6)
  end
end
