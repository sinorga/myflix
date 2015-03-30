module StripeWrapper
  class CardError < StandardError
  end

  class Charge
    def self.create(opt={})
      begin
        charge = Stripe::Charge.create(
          :amount => opt[:amount], # amount in cents, again
          :currency => "usd",
          :source => opt[:source],
          :description => opt[:description]
        )
      rescue Stripe::CardError => e
        raise CardError.new(e.message)
      end
    end
    def self.set_api_key(key)
      Stripe.api_key = key
    end
  end
end
