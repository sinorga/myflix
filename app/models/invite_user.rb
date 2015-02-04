class InviteUser < ActiveRecord::Base
  belongs_to :inviter, class_name: "User", foreign_key: 'user_id'

  validates_presence_of :name, :email, :message
  validates_uniqueness_of :email, scope: :user_id
  before_create :generate_token

  protected
  def generate_token
    self.token = SecureRandom.urlsafe_base64
  end
end
