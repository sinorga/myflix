StripeWrapper.set_api_key(ENV['STRIPE_SECRET_KEY'])

StripeEvent.configure do |events|
  events.subscribe 'charge.succeeded', StripeWrapper::EventHandler::ChargeSucceeded.new
  events.subscribe 'charge.failed', StripeWrapper::EventHandler::ChargeFailed.new
end
