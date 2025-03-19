# frozen_string_literal: true

module Web
  class AuthControllerTest < ActionDispatch::IntegrationTest
    test 'check github auth' do
      post auth_request_path('github')

      assert_response(:redirect)
    end

    test 'create' do
      auth_hash = {
        provider: 'github',
        uid: '12345',
        info: {
          email: Faker::Internet.email,
          name: Faker::Name.first_name,
          nickname: Faker::Internet.username,
          image: Faker::Avatar.image
        },
        credentials: {
          token: Faker::Crypto.md5
        }
      }

      OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash::InfoHash.new(auth_hash)

      get callback_auth_url('github')

      assert_response(:redirect)

      user = User.find_by(email: auth_hash.dig(:info, :email))

      assert(user)

      assert_predicate(self, :signed_in?)
    end

    test 'logout check' do
      sign_in(users(:one))

      delete logout_path

      assert_nil(session[:user_id])
      assert_redirected_to(root_path)
    end
  end
end
