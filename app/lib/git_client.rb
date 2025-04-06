# frozen_string_literal: true

class GitClient
  STORAGE_PATH = Rails.root.join('storage/repositories')

  attr_reader :repository_name, :repository_url

  # @param [String] repository_name
  # @param [String] repository_url
  def initialize(repository_name:, repository_url:)
    @repository_name = repository_name
    @repository_url  = repository_url
  end

  # @return [Boolean]
  def clone_repository
    system("git clone #{@repository_url} #{full_repository_path}")
  end

  # @return [Boolean]
  def remove_repository
    system("rm -rf #{full_repository_path}")
  end

  # @return [String]
  def last_commit_hash
    stdout, = Open3.capture2("git -C #{full_repository_path} rev-parse HEAD")
    stdout.strip
  end

  # @return [Pathname]
  def full_repository_path
    @full_repository_path ||= STORAGE_PATH.join(repository_name)
  end
end
