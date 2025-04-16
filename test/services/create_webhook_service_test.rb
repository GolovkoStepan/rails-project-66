# frozen_string_literal: true

class CreateWebhookServiceTest < ActiveSupport::TestCase
  setup do
    @repository_full_name = 'user/test-repo'
    @token                = 'test-token'
    @service              = CreateWebhookService.new(@token, @repository_full_name)
  end

  test 'successful webhook creation' do
    octokit_client_stub                      = @service.send(:octokit_client)
    octokit_client_stub.raise_on_create_hook = false

    assert_nothing_raised { @service.call }

    expected_args = [
      @repository_full_name,
      'web',
      {
        url: Rails.application.routes.url_helpers.api_checks_url,
        content_type: 'json'
      },
      {
        events: CreateWebhookService::AVAILABE_EVENTS,
        active: true
      }
    ]

    assert { expected_args == octokit_client_stub.create_hook_args }
  end

  test 'webhook_url generation' do
    expected_url = Rails.application.routes.url_helpers.api_checks_url
    assert { expected_url == @service.send(:webhook_url) }
  end

  test 'error handling and logging' do
    octokit_client_stub                      = @service.send(:octokit_client)
    octokit_client_stub.raise_on_create_hook = true
    octokit_client_stub.error_message        = 'test error'

    Rails.logger.stub(:info, ->(msg) { @logged_message = msg }) do
      assert { @service.call.nil? }
      assert_includes @logged_message, 'CreateWebhookService failed: test error'
    end
  end

  test 'octokit_client initialization' do
    client = @service.send(:octokit_client)
    assert { client.is_a?(GithubClientStub) }
    assert { @token == client.instance_variable_get(:@access_token) }
    assert { client.instance_variable_get(:@auto_paginate) }
  end
end
