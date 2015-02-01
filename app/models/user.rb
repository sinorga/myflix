class User < ActiveRecord::Base
  has_many :reviews
  has_many :queue_items

  has_many :follower_maps, foreign_key: 'followee_id', class_name: 'Followership', dependent: :destroy
  has_many :followers, through: :follower_maps

  has_many :followee_maps, foreign_key: 'follower_id', class_name: 'Followership', dependent: :destroy
  has_many :followees, through: :followee_maps


  validates_presence_of :email, :full_name
  validates_presence_of :password
  validates_uniqueness_of :email
  has_secure_password validations: false

  def normalize_queue_items
    queue_items.each_with_index do |queue_item, index|
      queue_item.update(position: index+1)
    end
  end

  def queued_video?(video)
    queue_items.map(&:video).include?(video)
  end

  def can_follow?(followee)
    Followership.new(follower: self, followee: followee).valid?
  end

  def follow(followee)
    self.followees << followee if can_follow?(followee)
  end

  def generate_password_reset_token
    update_column(:password_reset_token, SecureRandom.urlsafe_base64)
  end

  def clear_password_reset_token
    update_column(:password_reset_token, nil)
  end
end
