# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'

require_relative '../config/environment'
require 'rails/test_help'

OmniAuth.config.test_mode = true

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all
  end
end

module ActionDispatch
  class IntegrationTest
    def sign_in(user)
      auth_hash = {
        provider: 'github',
        uid: Faker::Internet.uuid,
        info: {
          email: user.email,
          name: user.name
        },
        credentials: {
          token: Faker::Crypto.md5
        }
      }

      OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(auth_hash)

      get callback_auth_path(:github)
    end

    def signed_in?
      session[:user_id].present? && current_user.present?
    end

    def current_user
      @current_user ||= User.find_by(id: session[:user_id])
    end
  end
end
