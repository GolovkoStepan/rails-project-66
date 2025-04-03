# frozen_string_literal: true

# == Schema Information
#
# Table name: repository_check_offenses
#
#  id         :integer          not null, primary key
#  column     :integer
#  file_path  :string
#  line       :integer
#  message    :text
#  rule_name  :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  check_id   :integer          not null
#
# Indexes
#
#  index_repository_check_offenses_on_check_id  (check_id)
#
# Foreign Keys
#
#  check_id  (check_id => checks.id)
#
require 'test_helper'

class Repository::CheckOffenseTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
