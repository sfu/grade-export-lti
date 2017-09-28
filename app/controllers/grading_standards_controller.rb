class GradingStandardsController < ApplicationController
  def show
    @grading_standard = current_user.grading_standards.first
  end

  def new
    @grading_standard = current_user.grading_standards.new
  end

  def create
  end
end
