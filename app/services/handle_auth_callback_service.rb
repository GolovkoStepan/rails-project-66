# frozen_string_literal: true

class HandleAuthCallbackService < ApplicationService
  param :auth_params

  def call
    User.find_or_create_by!(email: github_info['email']).tap do |user|
      user.name      = github_info['name']
      user.nickname  = github_info['nickname']
      user.image_url = github_info['image']
      user.token     = github_info['token']

      user.save!
    end
  end

  private

  def github_info
    @github_info ||= auth_params['info']
  end
end
