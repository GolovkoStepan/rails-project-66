# frozen_string_literal: true

class Web::RepositoriesController < Web::ApplicationController
  before_action :authenticate_user!
  before_action :set_repository, only: %i[show]

  def index
    @repositories = current_user.repositories.order(created_at: :desc).page(params[:page]).per(20)
  end

  def show
    if @repository
      @checks = @repository.checks.order(created_at: :desc).page(params[:page]).per(20)
    else
      redirect_to repositories_path, alert: t('.not_found')
    end
  end

  def new
    @repository_form = RepositoryForm.with(user: current_user)
  end

  def create
    @repository_form = RepositoryForm.with(user: current_user).from(params.require(:repository))

    if @repository_form.save
      redirect_to repositories_path, notice: t('.success')
    else
      flash.now[:alert] = @repository_form.repository.errors.full_messages.join('\n')
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_repository
    @repository = current_user.repositories.find_by(id: params[:id])
  end
end
