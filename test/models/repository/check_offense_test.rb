# frozen_string_literal: true

# == Schema Information
#
# Table name: repository_check_offenses
#
#  id         :bigint           not null, primary key
#  column     :integer
#  file_path  :string
#  line       :integer
#  message    :text
#  rule_name  :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  check_id   :bigint           not null
#
# Indexes
#
#  index_repository_check_offenses_on_check_id  (check_id)
#
# Foreign Keys
#
#  fk_rails_...  (check_id => repository_checks.id)
#
class Repository::CheckOffenseTest < ActiveSupport::TestCase
  def setup
    @offense = repository_check_offenses(:one)
  end

  test 'should be valid' do
    assert @offense.valid?
  end

  test 'should belong to check' do
    assert_respond_to @offense, :check
    assert_kind_of Repository::Check, @offense.check
  end

  test 'should update offenses_count on check when created or destroyed' do
    check = repository_checks(:one)
    initial_count = check.offenses_count

    offense = check.offenses.create!(
      message: 'New offense',
      file_path: 'app/models/test.rb',
      line: 10,
      column: 5,
      rule_name: 'Style/TestRule'
    )

    assert_equal initial_count + 1, check.reload.offenses_count

    offense.destroy
    assert_equal initial_count, check.reload.offenses_count
  end

  test 'message should be optional' do
    @offense.message = nil
    assert @offense.valid?
  end

  test 'file_path should be optional' do
    @offense.file_path = nil
    assert @offense.valid?
  end

  test 'line should be optional' do
    @offense.line = nil
    assert @offense.valid?
  end

  test 'column should be optional' do
    @offense.column = nil
    assert @offense.valid?
  end

  test 'rule_name should be optional' do
    @offense.rule_name = nil
    assert @offense.valid?
  end

  test 'check_id should be present' do
    @offense.check_id = nil
    assert_not @offense.valid?
  end
end
