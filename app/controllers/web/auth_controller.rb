# frozen_string_literal: true

module Web
  class AuthController < ApplicationController
    def callback
      user = HandleAuthCallbackService.call(request.env['omniauth.auth'])
      session[:user_id] = user.id

      redirect_to root_path, notice: t('shared.auth.success')
    rescue StandardError => e
      Rails.logger.error("HandleAuthCallbackService error: #{e.message}")

      redirect_to root_path, alert: t('shared.auth.error')
    end

    def logout
      session[:user_id] = nil

      redirect_to root_path, notice: t('shared.auth.logout')
    end
  end
end
