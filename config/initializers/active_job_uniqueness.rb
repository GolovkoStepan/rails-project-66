# frozen_string_literal: true

require 'redis-client'

ActiveJob::Uniqueness.configure do |config|
  config.redlock_servers = [
    RedisClient.new(
      url: ENV.fetch('REDIS_URL', 'redis://localhost:6379/1'),
      ssl_params: { verify_mode: OpenSSL::SSL::VERIFY_NONE }
    )
  ]
end
