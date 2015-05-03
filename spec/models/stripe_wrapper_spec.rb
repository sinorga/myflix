require 'spec_helper'

describe StripeWrapper do
  describe StripeWrapper::Charge do
    describe ".create" do
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
          charge = StripeWrapper::Charge.create(
              :amount => 999, # amount in cents, again
              :source => token,
          )
          expect(charge.amount).to eq(999)
          expect(charge.currency).to eq('usd')
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
  end

  describe StripeWrapper::Customer do
    describe ".create" do
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
        it "customer subscribe successfully", :vcr do
          customer = StripeWrapper::Customer.create(
              :source => token,
              :email => "xxx@gmail.com"
          )
          expect(customer.email).to eq("xxx@gmail.com")
        end
      end

      context "with invalid card" do
        let(:card_number) { '4000000000000002' }
        it "raise an exception with error message", :vcr do
          expect{
            customer = StripeWrapper::Customer.create(
                :source => token,
                :email => "xxx@gmail.com"
            )
          }.to raise_error(StripeWrapper::CardError, "Your card was declined.")
        end
      end
    end
  end
end
