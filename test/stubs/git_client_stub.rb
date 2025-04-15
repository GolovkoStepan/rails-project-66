# frozen_string_literal: true

class GitClientStub
  STORAGE_PATH = Rails.root.join('tmp/repositories')

  attr_reader :repository_name, :repository_url

  # @param [String] repository_name
  # @param [String] repository_url
  def initialize(repository_name:, repository_url:)
    @repository_name = repository_name
    @repository_url  = repository_url
  end

  # @return [Boolean]
  def clone_repository
    true
  end

  # @return [Boolean]
  def remove_repository
    true
  end

  # @return [String]
  def last_commit_hash
    '68b95ea683d70e7b79e166c63ee21b7a936e36ec'
  end

  # @return [Pathname]
  def full_repository_path
    @full_repository_path ||= STORAGE_PATH.join(repository_name)
  end
end
