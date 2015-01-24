class Followership < ActiveRecord::Base
  belongs_to :follower, class_name: 'User'
  belongs_to :followee, class_name: 'User'
  validates_uniqueness_of :followee_id, scope: :follower_id
  validate :cant_follow_self

  def cant_follow_self
    if follower == followee
      errors.add(:followee, "can't follow yourself")
    end
  end
end
