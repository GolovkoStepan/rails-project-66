# frozen_string_literal: true

class Api::ChecksController < Api::ApplicationController
  def create
    HandleWebhookService.call(event_param, repository_github_id)
    head :ok
  end

  private

  def event_param
    @event_param ||= request.headers['X-GitHub-Event']
  end

  def repository_github_id
    @repository_github_id ||= params.dig(:repository, :id)
  end
end
