# frozen_string_literal: true

class Web::RepositoriesController < Web::ApplicationController
  before_action :authenticate_user!

  def index
    @repositories = current_user.repositories.order(created_at: :desc).page(params[:page]).per(20)
  end

  def show
    if (@repository = current_user.repositories.find_by(id: params[:id]))
      @checks = @repository.checks.order(created_at: :desc).page(params[:page]).per(20)
    else
      redirect_to repositories_path, alert: I18n.t('web.repositories.show.repository_not_found')
    end
  end

  def new
    @repository_form = RepositoryForm.with(user: current_user)
  end

  def create
    @repository_form = RepositoryForm.with(user: current_user).from(params.require(:repository))

    if @repository_form.save
      redirect_to repositories_path, notice: I18n.t('web.repositories.create.success')
    else
      flash.now[:alert] = @repository_form.repository.errors.full_messages.join('\n')
      render :new, status: :unprocessable_entity
    end
  end
end
