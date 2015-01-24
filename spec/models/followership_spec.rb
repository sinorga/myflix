require 'spec_helper'

describe Followership do
  it { should belong_to(:followee).class_name('User') }
  it { should belong_to(:follower).class_name('User') }
  it { should validate_uniqueness_of(:followee_id).scoped_to(:follower_id) }

  it "validates follower can't follow himself" do
    alice = Fabricate(:user)
    expect(Followership.create(follower: alice, followee: alice).valid?).to be_falsy
  end
end
