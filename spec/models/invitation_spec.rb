require 'spec_helper'

describe Invitation do
  it { should belong_to(:inviter).class_name('User') }
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:message) }
  it { should validate_uniqueness_of(:email).scoped_to(:inviter_id) }

  it_behaves_like "tokenable" do
    let(:object) { Fabricate(:invitation) }
  end

  describe "#expire" do
    it "sets token to nil" do
      invitation = Fabricate(:invitation)
      invitation.expire
      expect(invitation.reload.token).to be_nil
    end
  end
end
