class GradingStandard < ApplicationRecord
  belongs_to :user

  serialize :grading_scheme, JSON

  default_scope -> { order(created_at: :desc) }
  validates :user_id, presence: true
  validates :title, presence: true, uniqueness: true
  # validates :grading_scheme, presence: true

  validate :grading_scheme_percentage

  def grading_scheme
    read_attribute(:grading_scheme).map {|v| GradingStandard::GradingScheme.new(v)}
  end

  def grading_scheme_attributes=(attributes)
    grading_schemes = []
    attributes.each do |index, attrs|
      next if '1' == attrs.delete("_destroy")
      attrs[:percentage] = attrs[:percentage].try(:to_i)
      grading_schemes << attrs
    end
    write_attribute(:grading_scheme, grading_schemes)
  end

  class GradingScheme
    extend ActiveModel::Naming
    include ActiveModel::Conversion
    attr_accessor :name, :percentage

    def persisted?() false; end
    def new_record?() false; end
    def marked_for_destruction?() false; end
    def _destroy() false; end

    def initialize(hash)
      @name = hash['name']
      @percentage = hash['percentage'].to_i
    end
  end

  private
  def grading_scheme_percentage
    self.grading_scheme.map(&:percentage).each_cons(2) do |left, right|
      if !right.between?(0, 100) || !left.between?(0, 100)
        self.errors.add(:grading_scheme, "Grades must be between 0 and 100")
      end

      if left <= right
        self.errors.add(:grading_scheme, "Grades must be in descending order")
      end
    end
  end

end
