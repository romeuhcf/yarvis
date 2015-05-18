source 'https://rubygems.org'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.1.8'
# Use mysql as the database for Active Record
gem 'mysql2'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.3'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer',  platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0',          group: :doc

# Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
gem 'spring',        group: :development

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use unicorn as the app server
# gem 'unicorn'

# Use debugger
# gem 'debugger', group: [:development, :test]
gem 'bootstrap-sass'
gem "sidekiq"
gem 'sidetiq'
gem 'sidekiq-limit_fetch'
gem 'sinatra', :require => nil

gem 'jquery-ui-rails'
gem 'rails_admin'
gem 'newrelic_rpm'
gem 'easy_config'
gem 'thin'
gem 'rugged'

group :development, :test do
  gem 'sqlite3'
  gem 'quiet_assets'
  gem 'factory_girl_rails'
  gem 'rspec-rails'
  gem 'capistrano', '>= 3.2.1'
  gem 'rvm1-capistrano3', require: false

  gem 'capistrano-bundler'
  gem 'capistrano-rails'
  gem 'capistrano-sidekiq'
  gem 'capistrano-passenger'
end

group :test do
  gem 'capybara'
  gem 'cucumber-rails', require: false
  gem 'database_cleaner', '>= 1.0.1'
  gem 'simplecov', '~> 0.7.1', require: false
  gem 'faker'
end
