# frozen_string_literal: true

class Web::ApplicationController < ActionController::Base
  allow_browser versions: :modern

  helper_method :current_user, :user_signed_in?

  private

  def authenticate_user!
    return if user_signed_in?

    redirect_to root_path, alert: I18n.t('shared.auth.need_authentication')
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def user_signed_in?
    session[:user_id].present? && current_user.present?
  end
end
