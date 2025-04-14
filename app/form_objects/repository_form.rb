# frozen_string_literal: true

class RepositoryForm < ApplicationForm
  attribute :github_id, :integer

  attr_reader :repository, :user

  after_commit :create_webhook
  after_commit :enqueue_check_repository_job

  class << self
    delegate :with, to: :new
  end

  # @param user [User]
  # @return [RepositoryForm]
  def with(user:)
    @user = user
    self
  end

  # @return [Array<Array<String, Integer>]
  def user_repositories_collection
    user_repositories.map { |repository_info| [repository_info.full_name, repository_info.id] }
  end

  # @return [Repository]
  def model = repository

  private

  attr_writer :repository

  # @return [Boolean]
  def submit!
    self.repository = user.repositories.find_or_initialize_by(github_id:)
    repository_info = octokit_client.repo(github_id)

    repository.name      = repository_info[:name]
    repository.full_name = repository_info[:full_name]
    repository.language  = repository_info[:language]&.downcase
    repository.clone_url = repository_info[:clone_url]
    repository.ssh_url   = repository_info[:ssh_url]

    repository.save!
  end

  # @return [Octokit::Client, GithubClientStub]
  def octokit_client
    @octokit_client ||=
      ApplicationContainer[:github_client]
      .new(access_token: user.token, auto_paginate: true)
  end

  # @return [Array<Hash>]
  def user_repositories
    @user_repositories ||=
      octokit_client
      .repos
      .select { |repo| Repository::AVAILABLE_LANGUAGES.include?(repo[:language]&.downcase&.to_sym) }
  end

  # @return [Void]
  def create_webhook
    CreateWebhookService.call(user.token, repository.full_name)
  end

  # @return [Void]
  def enqueue_check_repository_job
    CheckRepositoryJob.perform_async(repository.id)
  end
end
