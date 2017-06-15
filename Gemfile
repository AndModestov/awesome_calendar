source 'https://rubygems.org'

ruby '2.3.1'
gem 'rails', '5.0.1'

gem 'pg'
gem 'sass-rails'
gem 'coffee-rails'
gem 'jquery-rails'
gem 'jbuilder'
gem 'slim-rails'
gem 'devise'
gem 'twitter-bootstrap-rails'
# gem 'carrierwave'
# gem 'omniauth'
# gem 'omniauth-facebook'
gem 'cancancan'
gem 'active_model_serializers'
# gem 'sidekiq'
# gem 'sinatra', '>= 1.3.0', require: nil
gem 'dotenv'
gem 'dotenv-deployment', require: 'dotenv/deployment'
gem 'therubyracer'
# gem 'unicorn'
# gem 'redis-rails'

gem 'sdoc', group: :doc

group :development do
  # gem 'capistrano', require: false
  # gem 'capistrano-bundler', require: false
  # gem 'capistrano-rails', require: false
  # gem 'capistrano-rvm', require: false
  # gem 'capistrano-sidekiq', require: false
  # gem 'capistrano3-unicorn'
end

group :test, :development do
  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'capybara'
  gem 'launchy'
  gem 'capybara-webkit'
  gem 'selenium-webdriver'
  gem 'database_cleaner'
end

group :test do
  gem 'shoulda-matchers', git: 'https://github.com/thoughtbot/shoulda-matchers.git', branch: 'rails-5'
  gem 'rails-controller-testing'
  gem 'json_spec'
end
