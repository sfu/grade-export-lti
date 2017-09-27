class GradingStandardsController < ApplicationController
  def show
  end

  def new
    @grading_standard = current_user.grading_standards.new
  end

  def create
  end
end
