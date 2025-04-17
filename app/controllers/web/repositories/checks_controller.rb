# frozen_string_literal: true

class Web::Repositories::ChecksController < Web::ApplicationController
  before_action :authenticate_user!
  before_action :set_repository

  def show
    if (@check = @repository.checks.find_by(id: params[:id]))
      @offenses = @check.offenses.page(params[:page]).per(30)
    else
      redirect_to repository_path(@repository), alert: t('.not_found')
    end
  end

  def create
    CheckRepositoryJob.perform_async(@repository.id)
    redirect_to repository_path(@repository), notice: t('.success')
  rescue SidekiqUniqueJobs::Conflict
    redirect_to repository_path(@repository), alert: t('.already_in_progress')
  end

  private

  def set_repository
    @repository = current_user.repositories.find(params[:repository_id])
  end
end
