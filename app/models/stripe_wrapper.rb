module StripeWrapper
  def self.set_api_key(key)
    Stripe.api_key = key
  end

  class CardError < StandardError
  end

  class Charge
    def self.create(opt={})
      begin
        Stripe::Charge.create(
          amount: opt[:amount], # amount in cents, again
          currency: "usd",
          source: opt[:source],
          description: opt[:description]
        )
      rescue Stripe::CardError => e
        raise CardError.new(e.message)
      end
    end
  end

  class Customer
    attr_reader :customer_id

    def initialize(customer_id)
      @customer_id = customer_id
    end
    
    def self.create(opt={})
      user = opt[:user]
      begin
        customer = Stripe::Customer.create(
          source: opt[:source],
          plan: "gold",
          email: user.email
        )
        new(customer.id)
      rescue Stripe::CardError => e
        raise CardError.new(e.message)
      end
    end
  end

  module EventHandler
    class ChargeSucceeded
      def call(event)
        charge = event.data.object
        user = User.find_by!(stripe_id: charge.customer)
        user.payments.create!(amount: charge.amount, stripe_charge_id: charge.id)
      end
    end
  end
end
