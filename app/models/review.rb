class Review < ActiveRecord::Base
  belongs_to :user
  belongs_to :video
  validates_presence_of :rating, :content
  validates_inclusion_of :rating, in: 0..5
end
