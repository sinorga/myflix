if Rails.env.development? or Rails.env.test?
  ENV['STRIPE_PUBLISHABLE_KEY'] = "pk_test_jS6BKf6bMnfVZ9BiaUf533kd"
  ENV['STRIPE_SECRET_KEY'] = "sk_test_oRx3n1ew0kZIkY9hLvPMV8Dy"
end

Stripe.api_key = ENV['STRIPE_SECRET_KEY']
