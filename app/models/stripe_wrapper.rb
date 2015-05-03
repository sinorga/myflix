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
    def self.create(opt={})
      user = opt[:user]
      begin
        customer = Stripe::Customer.create(
          source: opt[:source],
          plan: "gold",
          email: user.email
        )
        user.update!(strip_id: customer.id)
      rescue Stripe::CardError => e
        raise CardError.new(e.message)
      end
    end
  end
end
