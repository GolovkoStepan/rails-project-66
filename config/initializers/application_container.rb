# frozen_string_literal: true

require 'dry/container'

class ApplicationContainer
  extend Dry::Container::Mixin

  if Rails.env.test?
    require Rails.root.join('test/stubs/github_client_stub')
    require Rails.root.join('test/stubs/git_client_stub')
    require Rails.root.join('test/stubs/linter_runner/rubocop_stub')
    require Rails.root.join('test/stubs/linter_runner/eslint_stub')

    register :github_client, -> { GithubClientStub }
    register :git_client,    -> { GitClientStub }
    register :rubocop,       -> { LinterRunner::RubocopStub }
    register :eslint,        -> { LinterRunner::EslintStub }
  else
    register :github_client, -> { Octokit::Client }
    register :git_client,    -> { GitClient }
    register :rubocop,       -> { LinterRunner::Rubocop }
    register :eslint,        -> { LinterRunner::Eslint }
  end
end
