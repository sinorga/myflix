require 'spec_helper'

describe "Charge payment" do
  def stub_event(status = 200)
    stub_request(:get, "https://api.stripe.com/v1/events/#{event_id}").
      to_return(status: status, body: event_data)
  end

  describe "Payment charged successful" do
    let(:event_id) {"evt_15yNEr4EwpIVSrdkwSGYWCvC"}
    let(:event_data) { File.read("spec/fixtures/stripe_events/evt_charge_succeeded.json") }
    let!(:alice) { Fabricate(:user, stripe_id: "cus_6AigMqcxfS02rf") }
    before do
      stub_event
      post "/stripe_events", JSON.parse(event_data)
    end
    it "creates a payment from webhooks of Stripe for charge succeeded" do
      expect(Payment.count).to eq(1)
    end

    it "creates a payment associate with user" do
      expect(Payment.first.user).to eq(alice)
    end

    it "creates a payment with amount" do
      expect(Payment.first.amount).to eq(999)
    end
  end

  describe "Payment charged falsely" do

    context "failed at beginning" do
      let(:event_id) {"evt_160QNk4EwpIVSrdkwIz8Ht5q"}
      let(:event_data) { File.read("spec/fixtures/stripe_events/evt_charge_failed_at_begin.json") }
      before do
        ActionMailer::Base.deliveries.clear
        stub_event
        post "/stripe_events", JSON.parse(event_data)
      end
      it "does not send out notify email" do
        expect(ActionMailer::Base.deliveries).to be_empty
      end
    end

    context "failed after first charge" do
      let(:event_id) {"evt_160QNk4EwpIVSrdkwIz8Ht5q"}
      let(:event_data) { File.read("spec/fixtures/stripe_events/evt_charge_failed.json") }
      let!(:alice) { Fabricate(:user, stripe_id: "cus_6AigMqcxfS02rf") }
      before do
        ActionMailer::Base.deliveries.clear
        stub_event
        post "/stripe_events", JSON.parse(event_data)
      end
      it "does not create payment from webhooks of Stripe for charge failed" do
        expect(Payment.count).to eq(0)
      end

      it "set the user unavailable" do
        expect(alice.reload).not_to be_active
      end

      context "sends charge failed email" do
        it "sends out the email" do
          expect(ActionMailer::Base.deliveries).not_to be_empty
        end

        it "sends to the charge failed user" do
          message = ActionMailer::Base.deliveries.last
          expect(message.to).to eq([alice.email])
        end

        it "has the right content" do
          message = ActionMailer::Base.deliveries.last
          expect(message.body).to include(alice.full_name)
        end
      end
    end
  end
end
