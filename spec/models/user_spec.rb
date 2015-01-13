require 'spec_helper'

describe User do
  it { should have_many(:reviews) }
  it { should have_many(:queue_items) }
  it { should validate_presence_of(:email) }
  it { should validate_uniqueness_of(:email) }
  it { should validate_presence_of(:password) }
  it { should validate_presence_of(:full_name) }
  it { should have_many(:follower_maps).with_foreign_key('followee_id').class_name('Followership') }
  it { should have_many(:followers).through(:follower_maps) }

  it { should have_many(:followee_maps).with_foreign_key('follower_id').class_name('Followership') }
  it { should have_many(:followees).through(:followee_maps) }

  describe "#queued_video?" do
    it "returns true when the user queued the video" do
      user = Fabricate(:user)
      video = Fabricate(:video)
      quque_item = Fabricate(:queue_item, user: user, video: video)

      expect(user.queued_video?(video)).to be_truthy

    end
    it "returns false when the user hasn't queueed the video" do
      user = Fabricate(:user)
      video = Fabricate(:video)

      expect(user.queued_video?(video)).to be_falsey
    end
  end
end
