require 'spec_helper'

describe "Payment charged successful" do
  let(:event_id) {"evt_15yNEr4EwpIVSrdkwSGYWCvC"}
  let(:event_data) { File.read("spec/fixtures/stripe_events/#{event_id}.json") }
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

  def stub_event(status = 200)
    stub_request(:get, "https://api.stripe.com/v1/events/#{event_id}").
      to_return(status: status, body: event_data)
  end
end
