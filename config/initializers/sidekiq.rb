# frozen_string_literal: true

require 'sidekiq-unique-jobs'

Sidekiq.configure_server do |config|
  Rails.logger = Sidekiq.logger

  config.redis = { url: ENV.fetch('REDIS_URL', nil) }

  config.client_middleware do |chain|
    chain.add SidekiqUniqueJobs::Middleware::Client
  end

  config.server_middleware do |chain|
    chain.add SidekiqUniqueJobs::Middleware::Server
  end

  SidekiqUniqueJobs::Server.configure(config)
end

Sidekiq.configure_client do |config|
  config.redis = { url: ENV.fetch('REDIS_URL', nil) }

  config.client_middleware do |chain|
    chain.add SidekiqUniqueJobs::Middleware::Client
  end
end
