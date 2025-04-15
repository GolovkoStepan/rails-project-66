# frozen_string_literal: true

class CheckRepositoryService < ApplicationService
  LINTERS = {
    ruby: ApplicationContainer[:rubocop],
    javascript: ApplicationContainer[:eslint]
  }.with_indifferent_access.freeze

  param :repository

  # @return [Void]
  def call
    logger.info("Checking repository: #{repository.full_name}")
    start_check!

    logger.info("Linter started: #{linter_runner.class}")
    save_check_offenses!

    finish_check!
    logger.info("Check finished. Offenses count: #{check.offenses.count}")
  rescue StandardError => e
    logger.info("CheckRepositoryService failed: #{e.message}")
    check.fail!
  ensure
    git_client.remove_repository
    send_report_a_failure if check.failed? || !check.passed?
  end

  private

  # @return [Repository::Check]
  def check
    @check ||= repository.checks.create
  end

  # @return [LinterRunner::Base]
  def linter_runner
    @linter_runner ||= LINTERS[repository.language].new(git_client.full_repository_path)
  end

  # @return [GitClient]
  def git_client
    @git_client ||= ApplicationContainer[:git_client].new(
      repository_name: repository.full_name,
      repository_url: repository.clone_url
    )
  end

  # @return [Void]
  def start_check!
    git_client.remove_repository
    git_client.clone_repository
    check.update!(commit_id: git_client.last_commit_hash)
    check.start!
  end

  # @return [Void]
  def save_check_offenses!
    linter_runner.run.data.each do |file_offenses|
      file_offenses[:offenses].each do |offense|
        check.offenses.create!(
          file_path: file_offenses[:file_path],
          message: offense[:message],
          rule_name: offense[:rule_name],
          line: offense[:line],
          column: offense[:column]
        )
      end
    end
  end

  # @return [Void]
  def finish_check!
    check.update!(passed: check.offenses.none?)
    check.finish!
  end

  # @return [Void]
  def send_report_a_failure
    RepositoryCheckMailer.with(check:).report_a_failure.deliver_now!
  rescue StandardError => e
    logger.info("CheckRepositoryService failed: #{e.message}")
  end
end
