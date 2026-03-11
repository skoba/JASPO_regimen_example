# frozen_string_literal: true

source 'https://rubygems.org'

ruby '~> 3.4.0'

# Rails 8.1.2
gem 'rails', '~> 8.1.2'

# Database
gem 'pg', '~> 1.5'

# Use the Puma web server
gem 'puma', '>= 5.0'

# Hotwire: SPA-like page accelerator
gem 'turbo-rails'
gem 'stimulus-rails'

# Build JSON APIs with ease
gem 'jbuilder'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', require: false

# Use Active Storage variants
# gem 'image_processing', '~> 1.2'

group :development, :test do
  # Debugging tools
  gem 'debug', platforms: %i[mri mingw x64_mingw]

  # RSpec for testing
  gem 'rspec-rails', '~> 7.1'
  gem 'factory_bot_rails', '~> 6.4'
  gem 'faker', '~> 3.5'
end

group :development do
  # Speed up commands on slow machines / big apps
  # gem 'spring'

  # Console
  gem 'web-console'
end

group :test do
  # Test helpers
  gem 'shoulda-matchers', '~> 6.0'
  gem 'database_cleaner-active_record', '~> 2.2'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
