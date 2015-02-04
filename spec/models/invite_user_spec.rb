require 'spec_helper'

describe InviteUser do
  it { should belong_to(:inviter).class_name('User').with_foreign_key('user_id') }
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:message) }
  it { should validate_uniqueness_of(:email).scoped_to(:user_id) }

  it "generates token before create" do
    alice = Fabricate(:invite_user)
    expect(alice.token).not_to be_nil
  end
end
