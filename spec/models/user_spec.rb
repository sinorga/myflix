require 'spec_helper'

describe User do
  it { should have_many(:reviews) }
  it { should have_many(:queue_items) }
  it { should have_many(:invitations).with_foreign_key('inviter_id') }
  it { should validate_presence_of(:email) }
  it { should validate_uniqueness_of(:email) }
  it { should validate_presence_of(:password)}
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

  describe "#follow" do
    it "follows user" do
      alice = Fabricate(:user)
      bob = Fabricate(:user)
      alice.follow(bob)
      expect(alice.followees.count).to eq(1)
    end

    it "does not follow user if user can't be followed" do
      alice = Fabricate(:user)
      alice.follow(alice)
      expect(alice.followees.count).to eq(0)
    end
  end

  describe "#can_follow?" do
    it "returns true if user can be followed" do
      alice = Fabricate(:user)
      bob = Fabricate(:user)
      expect(alice.can_follow?(bob)).to be_truthy
    end

    it "returns false if user can't be followed" do
      alice = Fabricate(:user)
      expect(alice.can_follow?(alice)).to be_falsey
    end
  end

  describe "#generate_password_reset_token" do
    let(:alice) { Fabricate(:user) }
    before { alice.generate_password_reset_token }
    it "sets password_reset_token variable" do
      expect(alice.password_reset_token).not_to be_nil
    end

    it "saves the token" do
      expect(User.first.password_reset_token).not_to be_nil
    end
  end

  describe "#clear_password_reset_token" do
    let(:alice) { Fabricate(:user) }
    before { alice.clear_password_reset_token }
    it "clear password_reset_token variable" do
      expect(alice.password_reset_token).to be_nil
    end

    it "saves the token" do
      expect(User.first.password_reset_token).to be_nil
    end
  end
end
