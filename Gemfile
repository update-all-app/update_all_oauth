source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.0"

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem "rails"
# Use postgresql as the database for Active Record
gem "pg", ">= 0.18", "< 2.0"
# Use Puma as the app server
gem "puma", "~> 4.1"
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder', '~> 2.7'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'
# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", ">= 1.4.2", require: false

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
gem "rack-cors"

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem "dotenv-rails", "~> 2.7"
  gem "factory_bot_rails", "~> 6.1"
  gem "rspec_api_documentation", "~> 6.1"
end

group :development do
  gem "listen", "~> 3.2"
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem "spring"
  gem "spring-watcher-listen", "~> 2.0.0"
end

group :test do 
  gem "rspec-rails", "~> 4.0"
  gem "database_cleaner-active_record"
  gem "faker", "~> 2.15"

end
# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby]

gem "devise", :git => "https://github.com/heartcombo/devise.git", ref: "8bb358cf80a632d3232c3f548ce7b95fd94b6eb2"
gem "omniauth-oauth2"

gem "doorkeeper", "~> 5.4"
gem "faraday", "~> 1.3"
gem "jsonapi-serializer", "~> 2.2"

