Stripe.api_key=ENV['STRIPE_SECRET_KEY']

StripeEvent.configure do |events|
  events.subscribe 'charge.', StripeWrapper::EventHandler::Charge.new
end
