# frozen_string_literal: true

class HandleAuthCallbackServiceTest < ActiveSupport::TestCase
  def setup
    @valid_auth_params = {
      'info' => {
        'email' => 'test@example.com',
        'name' => 'Test User',
        'nickname' => 'tester',
        'image' => 'https://example.com/avatar.jpg'
      },
      'credentials' => {
        'token' => 'gho_testtoken123'
      }
    }
  end

  def test_creates_new_user_with_correct_attributes
    assert_difference 'User.count', 1 do
      user = HandleAuthCallbackService.call(@valid_auth_params)

      assert_equal 'test@example.com', user.email
      assert_equal 'Test User', user.name
      assert_equal 'tester', user.nickname
      assert_equal 'https://example.com/avatar.jpg', user.image_url
      assert_equal 'gho_testtoken123', user.token
    end
  end

  def test_updates_existing_user_with_new_attributes
    existing_user = User.create!(
      email: 'test@example.com',
      name: 'Old Name',
      nickname: 'oldnick',
      image_url: 'https://example.com/old.jpg',
      token: 'oldtoken'
    )

    user = HandleAuthCallbackService.call(@valid_auth_params)

    assert_equal existing_user.id, user.id
    assert_equal 'Test User', user.name
    assert_equal 'tester', user.nickname
    assert_equal 'https://example.com/avatar.jpg', user.image_url
    assert_equal 'gho_testtoken123', user.token
  end

  def test_logs_error_and_reraises_on_failure
    invalid_auth_params = @valid_auth_params.merge('info' => nil)

    mock_logger = Minitest::Mock.new
    mock_logger.expect(:error, true, [/HandleAuthCallbackService failed/])

    service = HandleAuthCallbackService.new(auth_params: invalid_auth_params)
    service.stub(:logger, mock_logger) { assert_raises(NoMethodError) { service.call } }

    assert_mock mock_logger
  end

  def test_github_info_returns_correct_data
    service = HandleAuthCallbackService.new(@valid_auth_params)
    assert_equal @valid_auth_params['info'], service.send(:github_info)
  end

  def test_github_credentials_returns_correct_data
    service = HandleAuthCallbackService.new(@valid_auth_params)
    assert_equal @valid_auth_params['credentials'], service.send(:github_credentials)
  end
end
