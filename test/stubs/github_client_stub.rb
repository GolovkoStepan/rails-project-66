# frozen_string_literal: true

require_relative 'github_repository_stub'

class GithubClientStub
  def initialize(*); end

  def repos(*)
    [
      GithubRepositoryStub.new(
        id: 1,
        name: 'test-repo',
        full_name: 'user/test-repo',
        language: 'Ruby',
        clone_url: 'https://github.com/user/test-repo.git',
        ssh_url: 'git@github.com:user/test-repo.git'
      )
    ]
  end

  def repo(*)
    GithubRepositoryStub.new(
      id: 1,
      name: 'test-repo',
      full_name: 'user/test-repo',
      language: 'Ruby',
      clone_url: 'https://github.com/user/test-repo.git',
      ssh_url: 'git@github.com:user/test-repo.git'
    )
  end
end
