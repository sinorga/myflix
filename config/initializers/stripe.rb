StripeWrapper.set_api_key(ENV['STRIPE_SECRET_KEY'])

StripeEvent.configure do |events|
  events.subscribe 'charge.succeeded', StripeWrapper::EventHandler::ChargeSucceeded.new
end
