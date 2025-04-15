# frozen_string_literal: true

# test/services/handle_webhook_service_test.rb

require 'test_helper'

class HandleWebhookServiceTest < ActiveSupport::TestCase
  def setup
    @repository = repositories(:one)
    @logger     = Rails.logger
  end

  def teardown
    Sidekiq::Job.clear_all
  end

  def test_ping_handler_logs_message
    mock_logger      = Minitest::Mock.new
    expected_message = "HandleWebhookService received ping event for repository: #{@repository.full_name}"
    mock_logger.expect(:info, true, [expected_message])

    service = HandleWebhookService.new('ping', @repository.github_id)
    service.stub(:logger, mock_logger) { service.call }

    assert_mock mock_logger
  end

  def test_push_handler_logs_message_and_enqueues_job
    mock_logger      = Minitest::Mock.new
    expected_message = "HandleWebhookService received push event for repository: #{@repository.full_name}"
    mock_logger.expect(:info, true, [expected_message])

    service = HandleWebhookService.new('push', @repository.github_id)
    service.stub(:logger, mock_logger) { service.call }

    assert_mock mock_logger
    assert_equal 1, CheckRepositoryJob.jobs.size

    job = CheckRepositoryJob.jobs.first
    assert_equal @repository.id, job['args'].first
  end

  def test_unsupported_event_logs_message
    mock_logger = Minitest::Mock.new
    mock_logger.expect(:info, true, ['HandleWebhookService received unsupported event: unknown_event'])

    service = HandleWebhookService.new('unknown_event', @repository.github_id)
    service.stub(:logger, mock_logger) { service.call }

    assert_mock mock_logger
    assert_equal 0, CheckRepositoryJob.jobs.size
  end

  def test_call_rescues_standard_error_and_logs
    mock_logger = Minitest::Mock.new
    mock_logger.expect(:info, true, [/HandleWebhookService failed/])

    service = HandleWebhookService.new('push', 999_999)
    service.stub(:logger, mock_logger) { service.call }

    assert_mock mock_logger
    assert_equal 0, CheckRepositoryJob.jobs.size
  end
end
