# frozen_string_literal: true

# == Schema Information
#
# Table name: repository_checks
#
#  id             :bigint           not null, primary key
#  aasm_state     :string           not null
#  offenses_count :integer          default(0), not null
#  passed         :boolean          default(FALSE), not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  commit_id      :string
#  repository_id  :bigint           not null
#
# Indexes
#
#  index_repository_checks_on_repository_id  (repository_id)
#
# Foreign Keys
#
#  fk_rails_...  (repository_id => repositories.id)
#
class Repository::CheckTest < ActiveSupport::TestCase
  def setup
    @check = repository_checks(:one)
  end

  test 'should be valid' do
    assert @check.valid?
  end

  test 'should belong to repository' do
    assert_respond_to @check, :repository
    assert_kind_of Repository, @check.repository
  end

  test 'should have many offenses' do
    assert_respond_to @check, :offenses
    assert_kind_of ActiveRecord::Associations::CollectionProxy, @check.offenses
  end

  test 'should initialize with created state' do
    new_check = Repository::Check.new(repository: repositories(:one))
    assert_equal 'created', new_check.aasm_state
  end

  test 'should transition from created to checking' do
    @check.start!
    assert_equal 'checking', @check.aasm_state
  end

  test 'should transition from checking to finished' do
    @check.start!
    @check.finish!
    assert_equal 'finished', @check.aasm_state
  end

  test 'should transition from checking to failed' do
    @check.start!
    @check.fail!
    assert_equal 'failed', @check.aasm_state
  end

  test 'should not transition from created to finished' do
    assert_raises(AASM::InvalidTransition) do
      @check.finish!
    end
  end

  test 'should not transition from created to failed' do
    assert_raises(AASM::InvalidTransition) do
      @check.fail!
    end
  end

  test 'passed should default to false' do
    new_check = Repository::Check.new(repository: repositories(:one))
    assert_equal false, new_check.passed
  end

  test 'repository_id should be present' do
    @check.repository_id = nil
    assert_not @check.valid?
  end

  test 'commit_id should be optional' do
    @check.commit_id = nil
    assert @check.valid?
  end
end
