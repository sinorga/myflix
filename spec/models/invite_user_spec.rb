require 'spec_helper'

describe InviteUser do
  it { should belong_to(:inviter).class_name('User') }
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:message) }
  it { should validate_uniqueness_of(:email).scoped_to(:inviter_id) }

  it_behaves_like "tokenable" do
    let(:object) { Fabricate(:invite_user) }
  end

  describe "#expire" do
    it "sets token to nil" do
      invite_user = Fabricate(:invite_user)
      invite_user.expire
      expect(invite_user.reload.token).to be_nil
    end
  end
end
