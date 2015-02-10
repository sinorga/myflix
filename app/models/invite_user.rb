class InviteUser < ActiveRecord::Base
  include Tokenable
  belongs_to :inviter, class_name: "User"

  validates_presence_of :name, :email, :message
  validates_uniqueness_of :email, scope: :inviter_id

  def expire
    update_column(:token, nil)
  end
end
