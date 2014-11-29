class Review < ActiveRecord::Base
  belongs_to :user
  belongs_to :video
  validates_presence_of :user_id, :video_id, :rating, :content
  validates_inclusion_of :rating, in: 1..5
end
