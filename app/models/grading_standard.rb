class GradingStandard < ApplicationRecord
  belongs_to :user

  serialize :grading_scheme, JSON

  default_scope -> { order(created_at: :desc) }
  validates :user_id, presence: true
  validates :title, presence: true
  # validates :grading_scheme, presence: true

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

    def persisted?
      false
    end

    def initialize(hash)
      @name = hash['name']
      @percentage = hash['percentage'].to_i
    end
  end

end
