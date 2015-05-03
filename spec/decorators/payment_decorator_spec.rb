require 'spec_helper'

describe PaymentDecorator do
  describe "#show_amount" do
    let(:payment) {Fabricate(:payment, amount: 125)}
    let(:payment_decorator) { PaymentDecorator.new(payment) }
    it "returns amount in US dollar" do
      expect(payment_decorator.show_amount).to eq("$1.25")
    end
  end
end
