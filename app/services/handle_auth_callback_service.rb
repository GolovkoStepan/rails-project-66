# frozen_string_literal: true

class HandleAuthCallbackService < ApplicationService
  param :auth_params

  # @return [User]
  def call
    User.find_or_create_by!(email: github_info['email']).tap do |user|
      user.name      = github_info['name']
      user.nickname  = github_info['nickname']
      user.image_url = github_info['image']
      user.token     = github_credentials['token']

      user.save!
    end
  rescue StandardError => e
    logger.error("HandleAuthCallbackService failed: #{e.message}")
    raise e
  end

  private

  # @return [Hash]
  def github_info
    @github_info ||= auth_params['info']
  end

  # @return [Hash]
  def github_credentials
    @github_credentials ||= auth_params['credentials']
  end
end
