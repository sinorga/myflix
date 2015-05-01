require 'spec_helper'

describe UserRegistrator do
  describe "#register" do
    before do
      ActionMailer::Base.deliveries.clear
    end
    context "with valid input" do
      let(:user) { Fabricate(:user) }
      let(:registrator) { UserRegistrator.new(user) }
      before do
        expect(StripeWrapper::Charge).to receive(:create)
      end

      it "creates user record" do
        registrator.register("xxxxxxxxxxxxx", nil)
        expect(User.count).to eq(1)
        expect(User.first.email).to eq(user.email)
        expect(User.first.authenticate(user.password)).not_to eq(false)
        expect(User.first.full_name).to eq(user.full_name)
      end

      it "returns self with success status" do
        result = registrator.register("xxxxxxxxxxxxx", nil)
        expect(result.success?).to be_truthy
        expect(result.message).to be_blank
      end

      context "sends welcome email" do
        before { registrator.register("xxxxxxxxxxxxx", nil) }
        it "sends out the email" do
          expect(ActionMailer::Base.deliveries).not_to be_empty
        end

        it "sends to the signed up user" do
          message = ActionMailer::Base.deliveries.last
          expect(message.to).to eq([user.email])
        end

        it "has the right content" do
          message = ActionMailer::Base.deliveries.last
          expect(message.body).to include(user.full_name)
        end
      end
    end

    context "with valid input and inviter" do
      let(:alice) { Fabricate(:user) }
      let(:invitation_from_alice) { Fabricate(:invitation, inviter: alice) }
      let(:bob) { Fabricate(:user, email: invitation_from_alice.email) }
      let(:registrator) do
        UserRegistrator.new(bob)
      end
      before do
        expect(StripeWrapper::Charge).to receive(:create)
          .with(
            :amount => 999,
            :source => "xxxxxxxxxxxxx",
            :description => "payment of #{bob.email}"
          )
        registrator.register("xxxxxxxxxxxxx", invitation_from_alice.token)
      end

      it "sets user follow the inviter" do
        bob = User.last
        expect(bob.followees.first).to eq(alice)
      end

      it "sets inviter follow the user" do
        bob = User.last
        expect(alice.followees.first).to eq(bob)
      end

      it "expires invitation record" do
        expect(Invitation.last.token).to be_nil
      end
    end

    context "with valid personal info and declined card" do
      let(:user) { Fabricate.build(:user) }
      let(:registrator) { UserRegistrator.new(user) }
      before do
        expect(StripeWrapper::Charge).to receive(:create)
          .with(
            :amount => 999,
            :source => "12341234",
            :description => "payment of #{user.email}"
          ).and_raise(StripeWrapper::CardError)
      end

      it "dose not create user record" do
        registrator.register("12341234", nil)
        expect(User.count).to eq(0)
      end

      it "returns self with card error status and message" do
        result = registrator.register("12341234", nil)
        expect(result).to be_instance_of(UserRegistrator)
        expect(result.success?).to be_falsey
        expect(result.card_error?).to be_truthy
        expect(result.message).to be_present
      end

      it "does not sent out the email" do
        registrator.register("12341234", nil)
        expect(ActionMailer::Base.deliveries).to be_empty
      end
    end

    context "with invalid personal info and valid card" do
      let(:user) { Fabricate.build(:invalid_user) }
      let(:registrator) { UserRegistrator.new(user) }
      before do
        expect(StripeWrapper::Charge).not_to receive(:create)
      end

      it "dose not create user record" do
        registrator.register("xxxxxxxxxxxxx", nil)
        expect(User.count).to eq(0)
      end

      it "returns self with record error status" do
        result = registrator.register("xxxxxxxxxxxxx", nil)
        expect(result).to be_instance_of(UserRegistrator)
        expect(result.success?).to be_falsey
        expect(result.card_error?).to be_falsey
        expect(result.message).to be_blank
      end

      it "does not sent out the email" do
        registrator.register("xxxxxxxxxxxxx", nil)
        expect(ActionMailer::Base.deliveries).to be_empty
      end
    end
  end
end
