# frozen_string_literal: true

require 'fileutils'
require 'open3'

class TestGitClient < ActiveSupport::TestCase
  def setup
    @repository_name = 'test_repo'
    @repository_url  = 'https://github.com/example/test_repo.git'
    @git_client      = GitClient.new(repository_name: @repository_name, repository_url: @repository_url)
    FileUtils.mkdir_p(GitClient::STORAGE_PATH)
  end

  def teardown
    FileUtils.rm_rf(GitClient::STORAGE_PATH)
  end

  def test_initialize
    assert_equal @repository_name, @git_client.repository_name
    assert_equal @repository_url, @git_client.repository_url
    assert_equal GitClient::STORAGE_PATH.join(@repository_name), @git_client.full_repository_path
  end

  def test_full_repository_path
    expected_path = GitClient::STORAGE_PATH.join(@repository_name)
    assert_equal expected_path, @git_client.full_repository_path
    assert_same @git_client.full_repository_path, @git_client.full_repository_path
  end

  def test_clone_repository_success
    GitClient
      .any_instance
      .stubs(:system)
      .with("git clone #{@repository_url} #{@git_client.full_repository_path}")
      .returns(true)

    assert @git_client.clone_repository
  end

  def test_clone_repository_failure
    GitClient
      .any_instance
      .stubs(:system)
      .with("git clone #{@repository_url} #{@git_client.full_repository_path}")
      .returns(false)

    assert_not @git_client.clone_repository
  end

  def test_remove_repository_success
    FileUtils.mkdir_p(@git_client.full_repository_path)
    GitClient
      .any_instance
      .stubs(:system).with("rm -rf #{@git_client.full_repository_path}")
      .returns(true)

    assert @git_client.remove_repository
  end

  def test_remove_repository_failure
    GitClient
      .any_instance
      .stubs(:system)
      .with("rm -rf #{@git_client.full_repository_path}")
      .returns(false)

    assert_not @git_client.remove_repository
  end

  def test_last_commit_hash
    FileUtils.mkdir_p(@git_client.full_repository_path)

    fake_commit_hash = 'abc123'
    Open3
      .stubs(:capture2)
      .with("git -C #{@git_client.full_repository_path} rev-parse HEAD")
      .returns([fake_commit_hash, nil])

    assert_equal fake_commit_hash, @git_client.last_commit_hash
  end

  def test_last_commit_hash_with_empty_repository
    Open3
      .stubs(:capture2)
      .with("git -C #{@git_client.full_repository_path} rev-parse HEAD")
      .returns(['', nil])

    assert_equal '', @git_client.last_commit_hash
  end
end
