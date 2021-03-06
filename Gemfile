source 'http://rubygems.org'
ruby '2.1.0'

gem 'rails', '3.2.21'

gem 'pg'
gem 'jquery-rails'
gem 'bcrypt-ruby', '~> 3.0.0'
gem 'active_model_serializers'
gem 'aws-sdk', '~> 1.3.4'

gem 'sidekiq'
gem 'sidekiq-failures'
gem 'sidekiq-unique-jobs'
gem 'rack-contrib'
gem 'soulmate', :require => 'soulmate/server', github: 'sethherr/soulmate'
gem 'geocoder'
gem "money-rails", "~> 0.5.0"
gem "i18n"
gem "haml-rails"
gem "journey", "~> 1.0.3"
gem 'kramdown'
gem 'haml-kramdown'
gem 'kaminari'
gem 'pg_search'
gem 'nokogiri'
gem 'carrierwave', '~> 0.9.0'
gem 'carrierwave_backgrounder'
gem 'rmagick'
gem "mini_magick" # a smaller implementation of rmagick, required for rqrcode
gem 'rqrcode-rails3'
gem 'strong_parameters'
gem 'libv8', '~> 3.16.14.7'
gem 'rb-readline', '~> 0.5.0'
gem 'backbone-on-rails', "~>0.9.10.0"
gem 'stripe', git: 'https://github.com/stripe/stripe-ruby'
gem 'jquery-datatables-rails', github: 'rweng/jquery-datatables-rails'
gem "acts_as_paranoid", "~>0.4.0"
gem "high_voltage"
gem 'omniauth-facebook'
gem 'omniauth'
gem "fog"
gem 'dalli'
gem 'draper', require: false
# gem 'rack-mini-profiler', require: 'false'
gem 'dotenv-rails', "~> 0.8", git: "https://github.com/bkeepers/dotenv"
gem 'wkhtmltopdf-binary'
gem 'wicked_pdf'
gem 'sitemap_generator'
gem 'whenever'
gem 'unicorn'
gem 'unicorn-worker-killer'

gem 'doorkeeper',   '~> 2.0.1'
gem 'wine_bouncer'
gem 'grape'
gem 'grape-active_model_serializers', git: "https://github.com/jrhe/grape-active_model_serializers"
gem 'grape-swagger'
gem 'swagger-ui_rails'
gem 'api-pagination'


gem 'rack-throttle'
gem 'secure_headers'

gem 'chartkick'
gem 'groupdate'

# gem 'localeapp'
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'therubyracer', '~> 0.12.1' , platforms: :ruby
  gem 'uglifier', '>= 1.0.3'
end

group :development do
  gem 'ruby_gntp'
  gem 'rerun'
  gem 'growl'
  gem 'guard'
  gem 'guard-rspec', '~> 4.2.10'
  gem 'guard-livereload'
  gem 'bullet'
  gem 'should_clean'
  gem "brakeman", :require => false
end

group :development, :test do
  gem 'rb-fsevent', '~> 0.9.1'
  gem 'rspec-rails'
  gem 'foreman'
  gem 'database_cleaner'
  gem 'json_spec'
end

group :test do
  gem 'factory_girl_rails'
  gem 'simplecov', require: false
  gem "codeclimate-test-reporter", require: nil
  gem 'rspec-sidekiq'
  gem 'shoulda-matchers'
  gem 'pry'
end
