# frozen_string_literal: true

# == Schema Information
#
# Table name: repositories
#
#  id         :integer          not null, primary key
#  clone_url  :string
#  full_name  :string
#  language   :string
#  name       :string
#  ssh_url    :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  github_id  :integer
#  user_id    :integer          not null
#
# Indexes
#
#  index_repositories_on_github_id  (github_id) UNIQUE
#  index_repositories_on_user_id    (user_id)
#
# Foreign Keys
#
#  user_id  (user_id => users.id)
#
class Repository < ApplicationRecord
  AVAILABLE_LANGUAGES = %i[ruby].freeze

  belongs_to :user
  has_many :checks, dependent: :destroy

  enum :language, AVAILABLE_LANGUAGES.index_with(&:to_s), validate: true

  validates :github_id, uniqueness: true

  def last_check_state
    false
  end
end
