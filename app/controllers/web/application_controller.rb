# frozen_string_literal: true

module Web
  class ApplicationController < ActionController::Base
    allow_browser versions: :modern

    helper_method :current_user, :user_signed_in?

    private

    def current_user
      @current_user ||= User.find_by(id: session[:user_id])
    end

    def user_signed_in?
      session[:user_id].present? && current_user.present?
    end
  end
end
