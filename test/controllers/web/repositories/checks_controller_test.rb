# frozen_string_literal: true

require 'test_helper'

class Web::Repositories::ChecksControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user       = users(:one)
    @repository = repositories(:one)
    @check      = repository_checks(:one)

    sign_in(@user)
  end

  test 'should get show' do
    get repository_check_url(@repository.id, @check.id)

    assert { response.successful? }
  end

  test 'should create check, sends email when offenses' do
    assert_difference('Repository::Check.count', 1) do
      Sidekiq::Testing.inline! do
        post repository_checks_url(@repository)
      end
    end

    assert { response.redirect? && response.location == repository_url(@repository) }
    assert { flash[:notice] == I18n.t('web.repositories.checks.create.success') }
    new_check = @repository.checks.last

    assert(new_check.passed)

    assert_emails 0
  end
end
