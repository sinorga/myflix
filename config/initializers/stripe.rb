if Rails.env.development? or Rails.env.test?
  Rails.configuration.stripe = {
    :publishable_key => "pk_test_jS6BKf6bMnfVZ9BiaUf533kd",
    :secret_key      => "sk_test_oRx3n1ew0kZIkY9hLvPMV8Dy"
  }
else
  Rails.configuration.stripe = {
    :publishable_key => ENV['PUBLISHABLE_KEY'],
    :secret_key      => ENV['SECRET_KEY']
  }
end

Stripe.api_key = Rails.configuration.stripe[:secret_key]
