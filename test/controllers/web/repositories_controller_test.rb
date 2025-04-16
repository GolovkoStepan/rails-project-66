# frozen_string_literal: true

class Web::RepositoriesControllerTest < ActionDispatch::IntegrationTest
  def setup
    sign_in(users(:one))
  end

  def repository_params
    {
      name: 'Hello-World',
      full_name: 'octocat/Hello-World',
      language: 'Ruby',
      ssh_url: 'git@github.com:octocat/Hello-World.git',
      clone_url: 'https://github.com/octocat/Hello-World.git'
    }
  end

  test 'should create repository' do
    assert_difference('Repository.count') do
      Sidekiq::Testing.inline! do
        post repositories_url, params: { repository: { github_id: 100_500 } }
      end
    end

    assert { response.redirect? && response.location == repositories_url }
    assert { flash[:notice] == I18n.t('web.repositories.create.success') }
  end

  test 'should get index' do
    get repositories_url

    assert { response.successful? }
  end

  test 'should get new' do
    get new_repository_url

    assert { response.successful? }
  end

  test 'should show repository' do
    repository = repositories(:one)
    get repository_url(repository)

    assert { response.successful? }
  end
end
