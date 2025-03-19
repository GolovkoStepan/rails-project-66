# frozen_string_literal: true

module Web
  class HomeControllerTest < ActionDispatch::IntegrationTest
    test 'should get show' do
      get root_path

      assert_response :success
    end
  end
end
