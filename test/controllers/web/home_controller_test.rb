# frozen_string_literal: true

class Web::HomeControllerTest < ActionDispatch::IntegrationTest
  test 'should get show' do
    get root_path
    assert_response :success
  end
end
