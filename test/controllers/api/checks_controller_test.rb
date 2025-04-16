# frozen_string_literal: true

class Api::ChecksControllerTest < ActionDispatch::IntegrationTest
  def setup
    @repository   = repositories(:three)
    @test_payload = { repository: { id: @repository.github_id } }.to_json
  end

  test 'should create check' do
    headers = {
      'X-GitHub-Event' => 'push',
      'Content-Type' => 'application/json'
    }

    assert_difference('Repository::Check.count', 1) do
      Sidekiq::Testing.inline! do
        post api_checks_url, params: @test_payload, headers:
      end
    end

    assert_response :ok

    check = @repository.reload.checks.last

    assert { check.passed }
    assert { check.finished? }
  end
end
