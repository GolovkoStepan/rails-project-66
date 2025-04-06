# frozen_string_literal: true

class CheckRepositoryJob < ApplicationJob
  queue_as :default

  unique :until_executed

  # @param [Integer] repository_id
  def perform(repository_id)
    CheckRepositoryService.call(Repository.find(repository_id))
  end
end
