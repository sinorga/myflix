require 'spec_helper'

describe Payment do
  it { should belong_to(:user) }

  describe "#full_name" do
    it "returns the full name of user" do
      user = Fabricate(:user)
      payment = Fabricate(:payment, user: user)
      expect(payment.full_name).to eq(user.full_name)
    end
  end

  describe "#email" do
    it "returns the email of user" do
      user = Fabricate(:user)
      payment = Fabricate(:payment, user: user)
      expect(payment.email).to eq(user.email)
    end
  end
end
