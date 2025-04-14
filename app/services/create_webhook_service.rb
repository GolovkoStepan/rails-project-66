# frozen_string_literal: true

class CreateWebhookService < ApplicationService
  AVAILABE_EVENTS = %w[push].freeze

  param :token
  param :repository_full_name

  # @return [Void]
  def call
    octokit_client.create_hook(
      repository_full_name,
      'web',
      {
        url: webhook_url,
        content_type: 'json'
      },
      {
        events: AVAILABE_EVENTS,
        active: true
      }
    )
  rescue StandardError => e
    logger.info("CreateWebhookService failed: #{e.message}")
    nil
  end

  private

  # @return [String]
  def webhook_url
    Rails.application.routes.url_helpers.api_checks_url
  end

  # @return [Octokit::Client, GithubClientStub]
  def octokit_client
    @octokit_client ||=
      ApplicationContainer[:github_client]
      .new(access_token: token, auto_paginate: true)
  end
end
