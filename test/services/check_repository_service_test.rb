# frozen_string_literal: true

class CheckRepositoryServiceTest < ActiveSupport::TestCase
  setup do
    @repository = repositories(:three)
    @service    = CheckRepositoryService.new(@repository)
  end

  test 'successful check with no offenses' do
    @service.call
    check = @repository.reload.checks.last

    assert { check.passed? }
    assert { check.finished? }
    assert { check.offenses.count.zero? }
    assert { check.commit_id == '68b95ea683d70e7b79e166c63ee21b7a936e36ec' }
  end

  test 'check with offenses' do
    offenses_data = [
      {
        file_path: 'app/models/test.rb',
        offenses: [
          { message: 'Line too long', rule_name: 'Metrics/LineLength', line: 42, column: 80 }
        ]
      }
    ]

    linter_stub = @service.send(:linter_runner)
    linter_stub.run_result_data = offenses_data
    @service.call

    check = Repository::Check.last
    assert { !check.passed? }
    assert { check.offenses_count == 1 }
  end

  test 'error handling' do
    linter_stub = @service.send(:linter_runner)
    linter_stub.raise_on_run = true

    assert_difference 'ActionMailer::Base.deliveries.size', 1 do
      @service.call
    end

    check = @repository.reload.checks.last

    assert { !check.passed? }
    assert { check.failed? }
  end
end
