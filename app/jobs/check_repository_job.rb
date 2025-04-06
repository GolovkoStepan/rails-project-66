# frozen_string_literal: true

class CheckRepositoryJob < ApplicationJob
  sidekiq_options lock: :until_executed, on_conflict: :raise

  # @param [Integer] repository_id
  def perform(repository_id)
    CheckRepositoryService.call(Repository.find(repository_id))
  end
end
