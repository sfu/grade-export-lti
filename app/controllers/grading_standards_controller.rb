class GradingStandardsController < ApplicationController
  def show
    @grading_standards = current_user.grading_standards
  end

  def new
    @grading_standard = current_user.grading_standards.new
  end

  def create
    @grading_standard = current_user.grading_standards.new(grading_standard_params)
    if @grading_standard.save
      flash[:success] = "New Grading Standard has been added"
      redirect_to @grading_standard
    else
      render 'new'
    end
  end

  private
  private
  def grading_standard_params
    params.required(:grading_standard).permit(:title, :grading_scheme)
  end
end
