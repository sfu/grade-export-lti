class GradingStandard < ApplicationRecord
  belongs_to :user
  serialize :grading_scheme
end
