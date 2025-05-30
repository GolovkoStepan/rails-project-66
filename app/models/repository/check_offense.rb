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
class Repository::CheckOffense < ApplicationRecord
  belongs_to :check, class_name: 'Repository::Check', counter_cache: :offenses_count
end
