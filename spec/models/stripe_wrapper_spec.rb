require 'spec_helper'

describe StripeWrapper::Charge do
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
  context "with valid card" do
    let(:card_number) { '4242424242424242' }
    it "charges the card successfully", :vcr do
      expect{
        charge = StripeWrapper::Charge.create(
          :amount => 999, # amount in cents, again
          :source => token,
        )
      }.to_not raise_error
    end
  end
  context "with invalid card" do
    let(:card_number) { '4000000000000002' }
    it "raise an exception with error message", :vcr do
      expect{
        charge = StripeWrapper::Charge.create(
          :amount => 999, # amount in cents, again
          :source => token,
        )
      }.to raise_error(StripeWrapper::CardError, "Your card was declined.")
    end
  end
end
