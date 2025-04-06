# frozen_string_literal: true

class Web::AuthController < Web::ApplicationController
  def callback
    user = HandleAuthCallbackService.call(request.env['omniauth.auth'])
    session[:user_id] = user.id

    redirect_to root_path, notice: t('shared.auth.success')
  rescue StandardError
    redirect_to root_path, alert: t('shared.auth.error')
  end

  def logout
    session[:user_id] = nil

    redirect_to root_path, notice: t('shared.auth.logout')
  end
end
