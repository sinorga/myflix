require 'spec_helper'

describe StripeWrapper do
  let(:token) do
    Stripe::Token.create(
      :card => {
        :number => card_number,
        :exp_month => 3,
        :exp_year => 2016,
        :cvc => "314"
      },
    ).id
  end
  describe StripeWrapper::Charge do
    describe ".create" do
      context "with valid card" do
        let(:card_number) { '4242424242424242' }
        it "charges the card successfully", :vcr do
          expect{
            StripeWrapper::Charge.create(
                :amount => 999, # amount in cents, again
                :source => token,
                )
          }.not_to raise_error
        end
      end

      context "with invalid card" do
        let(:card_number) { '4000000000000002' }
        it "raise an exception with error message", :vcr do
          expect{
            StripeWrapper::Charge.create(
              :amount => 999, # amount in cents, again
              :source => token,
            )
          }.to raise_error(StripeWrapper::CardError, "Your card was declined.")
        end
      end
    end
  end

  describe StripeWrapper::Customer do
    describe ".create" do
      let(:alice) { Fabricate(:user) }
      context "with valid card" do
        let(:card_number) { '4242424242424242' }
        it "customer subscribe successfully", :vcr do
          expect{
            StripeWrapper::Customer.create(
              :source => token,
              :user => alice
            )
          }.not_to raise_error
        end

        it "stores customer id in user" do
          StripeWrapper::Customer.create(
              :source => token,
              :user => alice
          )
          expect(alice.reload.stripe_id).to be_present
        end
      end

      context "with invalid card" do
        let(:card_number) { '4000000000000002' }
        it "raise an exception with error message", :vcr do
          expect{
            StripeWrapper::Customer.create(
                :source => token,
                :user => alice
            )
          }.to raise_error(StripeWrapper::CardError, "Your card was declined.")
        end
      end
    end
  end
end
