# frozen_string_literal: true

# == Schema Information
#
# Table name: repositories
#
#  id         :bigint           not null, primary key
#  clone_url  :string
#  full_name  :string
#  language   :string
#  name       :string
#  ssh_url    :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  github_id  :integer
#  user_id    :bigint           not null
#
# Indexes
#
#  index_repositories_on_github_id  (github_id) UNIQUE
#  index_repositories_on_user_id    (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class RepositoryTest < ActiveSupport::TestCase
  def setup
    @repository = repositories(:one)
  end

  test 'should be valid' do
    assert @repository.valid?
  end

  test 'github_id should be unique' do
    @repository.github_id = repositories(:two).github_id
    assert_not @repository.valid?
  end

  test 'should belong to user' do
    assert_respond_to @repository, :user
    assert_kind_of User, @repository.user
  end

  test 'should have many checks' do
    assert_respond_to @repository, :checks
    assert_kind_of ActiveRecord::Associations::CollectionProxy, @repository.checks
  end

  test 'language should be enum with valid values' do
    valid_languages = Repository::AVAILABLE_LANGUAGES.map(&:to_s)

    valid_languages.each do |lang|
      @repository.language = lang
      assert @repository.valid?
    end

    @repository.language = 'invalid_language'
    assert_not @repository.valid?
  end

  test 'name should be optional' do
    @repository.name = nil
    assert @repository.valid?
  end

  test 'full_name should be optional' do
    @repository.full_name = nil
    assert @repository.valid?
  end

  test 'user_id should be present' do
    @repository.user_id = nil
    assert_not @repository.valid?
  end

  test 'clone_url should be optional' do
    @repository.clone_url = nil
    assert @repository.valid?
  end

  test 'ssh_url should be optional' do
    @repository.ssh_url = nil
    assert @repository.valid?
  end
end
