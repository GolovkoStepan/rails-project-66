# frozen_string_literal: true

class RepositoryCheckMailerTest < ActionMailer::TestCase
  setup do
    @check      = repository_checks(:two)
    @repository = @check.repository
    @user       = @repository.user
  end

  test 'report_a_failure sends email with correct attributes' do
    email = RepositoryCheckMailer.with(check: @check).report_a_failure

    assert_emails(1) { email.deliver_now }
    assert { email.to == [@user.email] }

    expected_subject = I18n.t(
      'repository_check_mailer.report_a_failure.subject',
      repository_name: @repository.name
    )

    assert { expected_subject == email.subject }
  end
end
