# frozen_string_literal: true

source 'https://rubygems.org'

gem 'bootsnap', require: false
gem 'cssbundling-rails'
gem 'jbuilder'
gem 'jsbundling-rails'
gem 'puma', '>= 5.0'
gem 'rails', '~> 7.2.2', '>= 7.2.2.1'
gem 'slim-rails'
gem 'sprockets-rails'
gem 'sqlite3', '>= 1.4'
gem 'stimulus-rails'
gem 'turbo-rails'

gem 'pg'

gem 'faraday-retry'
gem 'octokit'
gem 'omniauth-github'
gem 'omniauth-rails_csrf_protection'

gem 'dry-container'
gem 'dry-initializer'

gem 'aasm'
gem 'after_commit_everywhere'
gem 'kaminari'
gem 'simple_form'

gem 'sidekiq'
gem 'sidekiq-unique-jobs'

gem 'foreman'

group :development, :test do
  gem 'debug', platforms: %i[mri windows], require: 'debug/prelude'
  gem 'faker'
end

group :development do
  gem 'annotate'
  gem 'dotenv-rails'
  gem 'letter_opener'
  gem 'web-console'

  gem 'brakeman', require: false
  gem 'rubocop-rails-omakase', require: false
  gem 'slim_lint', require: false
end

group :test do
  gem 'capybara'
  gem 'minitest-power_assert'
  gem 'mocha'
  gem 'selenium-webdriver'
  gem 'webmock'
end
