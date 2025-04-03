# frozen_string_literal: true

class RepositoryForm < ApplicationForm
  attribute :github_id, :integer

  attr_reader :repository, :user

  class << self
    delegate :with, to: :new
  end

  def with(user:)
    @user = user
    self
  end

  def user_repositories_collection
    user_repositories.map { |repository_info| [repository_info.full_name, repository_info.id] }
  end

  def model = repository

  private

  attr_writer :repository

  def submit!
    self.repository = user.repositories.find_or_initialize_by(github_id:)
    repository_info = octokit_client.repo(github_id)

    repository.name      = repository_info[:name]
    repository.full_name = repository_info[:full_name]
    repository.language  = repository_info[:language]&.downcase
    repository.clone_url = repository_info[:clone_url]
    repository.ssh_url   = repository_info[:ssh_url]

    repository.save
  end

  def octokit_client
    @octokit_client ||=
      ApplicationContainer[:github_client]
      .new(access_token: user.token, auto_paginate: true)
  end

  def user_repositories
    @user_repositories ||=
      octokit_client
      .repos
      .select { |repo| Repository::AVAILABLE_LANGUAGES.include?(repo[:language]&.downcase&.to_sym) }
  end
end
