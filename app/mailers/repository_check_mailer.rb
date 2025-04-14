# frozen_string_literal: true

class RepositoryCheckMailer < ApplicationMailer
  before_action :set_attributes

  def report_a_failure
    mail(
      to: @user.email,
      subject: t('.subject', repository_name: @repository.name)
    )
  end

  private

  def set_attributes
    @check      = params[:check]
    @repository = @check.repository
    @user       = @repository.user
  end
end
