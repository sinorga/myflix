class Payment < ActiveRecord::Base
  belongs_to :user

  delegate :full_name, to: :user
  delegate :email, to: :user
end
