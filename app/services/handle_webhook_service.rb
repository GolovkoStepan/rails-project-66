# frozen_string_literal: true

class HandleWebhookService < ApplicationService
  AVAILABLE_EVENTS = %i[ping push].freeze

  param :event
  param :repository_github_id

  # @return [Void]
  def call
    return unsupported_event_handler unless AVAILABLE_EVENTS.include?(event.to_sym)

    send("#{event}_handler")
  rescue StandardError => e
    logger.info("HandleWebhookService failed: #{e.message}")
  end

  private

  # @return [Repository]
  def repository
    @repository ||= Repository.find_by!(github_id: repository_github_id)
  end

  # @return [Void]
  def ping_handler
    logger.info("HandleWebhookService received ping event for repository: #{repository.full_name}")
  end

  # @return [Void]
  def push_handler
    logger.info("HandleWebhookService received push event for repository: #{repository.full_name}")
    CheckRepositoryJob.perform_async(repository.id)
  end

  # @return [Void]
  def unsupported_event_handler
    logger.info("HandleWebhookService received unsupported event: #{event}")
  end
end
