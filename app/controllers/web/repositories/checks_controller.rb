# frozen_string_literal: true

class Web::Repositories::ChecksController < Web::ApplicationController
  before_action :authenticate_user!

  def show
    @check    = Repository::Check.includes(:repository).find(params[:id])
    @offenses = @check.offenses.page(params[:page]).per(30)
  end

  def create
    repository = Repository.find(params[:repository_id])
    CheckRepositoryJob.perform_later(repository.id)

    redirect_to repository_path(repository), notice: t('.success')
  rescue ActiveJob::Uniqueness::JobNotUnique
    redirect_to repository_path(repository), alert: t('.already_in_progress')
  end
end
