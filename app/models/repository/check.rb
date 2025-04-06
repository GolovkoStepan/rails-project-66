# frozen_string_literal: true

# == Schema Information
#
# Table name: repository_checks
#
#  id             :integer          not null, primary key
#  aasm_state     :string           not null
#  offenses_count :integer          default(0), not null
#  passed         :boolean          default(FALSE), not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  commit_id      :string
#  repository_id  :integer          not null
#
# Indexes
#
#  index_repository_checks_on_repository_id  (repository_id)
#
# Foreign Keys
#
#  repository_id  (repository_id => repositories.id)
#
class Repository::Check < ApplicationRecord
  include AASM

  belongs_to :repository
  has_many :offenses, class_name: 'Repository::CheckOffense', dependent: :destroy

  aasm column: :aasm_state do
    state :created, initial: true
    state :checking, :finished, :failed

    event :start do
      transitions from: :created, to: :checking
    end

    event :finish do
      transitions from: :checking, to: :finished
    end

    event :fail do
      transitions from: :checking, to: :failed
    end
  end
end
