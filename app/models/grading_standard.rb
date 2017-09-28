class GradingStandard < ApplicationRecord
  belongs_to :user
  # serialize :grading_scheme
  default_scope -> { order(created_at: :desc) }
  validates :user_id, presence: true
  # validates :grading_scheme, presence: true

  def grading_scheme
    JSON.parse(read_attribute(:grading_scheme)).map {|v| GradingStandard::GradingScheme.new(v)}
  end

  class GradingScheme
    attr_accessor :name, :percentage

    def initialize(hash)
      @name = hash['name']
      @percentage = hash['percentage'].to_i
    end
  end

end
