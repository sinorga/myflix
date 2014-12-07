class Review < ActiveRecord::Base
  belongs_to :user
  belongs_to :video
  validates_presence_of :user_id, :video_id, :rating
  validates_presence_of :content, unless: :skip_content
  validates_inclusion_of :rating, in: 1..5

  attr_accessor :skip_content
end
