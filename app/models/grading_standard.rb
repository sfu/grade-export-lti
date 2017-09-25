class GradingStandard < ApplicationRecord
  belongs_to :user
  # serialize :grading_scheme
  default_scope -> { order(created_at: :desc) }
  validates :user_id, presence: true
  # validates :grading_scheme, presence: true
end
