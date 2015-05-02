source 'https://rubygems.org'
ruby '2.1.2'

gem 'bootstrap-sass'
gem 'bootstrap_form'
gem 'bcrypt'
gem 'coffee-rails'
gem 'rails', '4.1.1'
gem 'haml-rails'
gem 'sass-rails'
gem 'uglifier'
gem 'jquery-rails'
gem 'pg'
gem 'sidekiq'
gem 'unicorn'
gem 'paratrooper'
gem 'carrierwave'
gem "mini_magick"
gem "fog"
gem 'stripe'
gem 'figaro'
gem 'draper'

group :development do
  gem 'thin'
  gem "better_errors"
  gem "binding_of_caller"
  gem "letter_opener"
  gem "foreman"
end

group :development, :test do
  gem 'pry'
  gem 'pry-nav'
  gem 'rspec-rails', '2.99'
  gem 'fabrication'
  gem 'faker'
end

group :test do
  gem 'database_cleaner', '1.2.0'
  gem 'shoulda-matchers', require: false
  gem 'capybara'
  gem 'launchy'
  gem 'capybara-email'
  gem 'vcr'
  gem 'webmock'
  gem 'selenium-webdriver'
end

group :production, :staging do
  gem 'rails_12factor'
  gem "sentry-raven"
end
