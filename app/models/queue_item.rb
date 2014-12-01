class QueueItem < ActiveRecord::Base
  belongs_to :user
  belongs_to :video
  validates_uniqueness_of :position
end
