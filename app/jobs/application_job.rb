# frozen_string_literal: true

class ApplicationJob
  include Sidekiq::Job

  sidekiq_options queue: :async_jobs, retry: false

  def perform(*)
    raise NotImplementedError
  end
end
