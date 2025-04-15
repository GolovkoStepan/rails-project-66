# frozen_string_literal: true

require_relative 'github_repository_stub'

class GithubClientStub
  attr_reader :access_token, :auto_paginate

  attr_accessor :raise_on_create_hook,
                :create_hook_args,
                :create_hook_result,
                :error_message

  # @param access_token [String]
  # @param auto_paginate [Boolean]
  def initialize(access_token:, auto_paginate:)
    @access_token         = access_token
    @auto_paginate        = auto_paginate
    @raise_on_create_hook = false
    @create_hook_args     = []
    @create_hook_result   = { id: 1, active: true }
    @error_message        = 'error'
  end

  # @return [Array<GithubRepositoryStub>]
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

  # @return [GithubRepositoryStub]
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

  # @return [Hash]
  def create_hook(*args)
    self.create_hook_args = args
    raise(StandardError, error_message) if raise_on_create_hook

    create_hook_result
  end
end
