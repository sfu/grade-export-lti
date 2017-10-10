class GradingStandardsController < ApplicationController

  def index
    @grading_standards = current_user.grading_standards
  end

  def show
    @grading_standard = current_user.grading_standards.find(params[:id])
  end

  def new
    @grading_standard = current_user.grading_standards.new
  end

  def create
    @grading_standard = current_user.grading_standards.new(grading_standard_params)
    if @grading_standard.save
      flash[:success] = "New Grading scheme has been added"
      redirect_to grading_standards_path
    else
      render 'new'
    end
  end

  def edit
    @grading_standard = current_user.grading_standards.find(params[:id])
  end

  def update
    @grading_standard = current_user.grading_standards.find(params[:id])
    @gs_params = grading_standard_params
    #render 'show'
    if @grading_standard.update_attributes(grading_standard_params)
      flash[:success] = "Grading scheme has been updated"
      redirect_to grading_standards_path
    else
      render 'edit'
    end
  end

  def destroy
    grading_standard = current_user.grading_standards.find(params[:id])
    grading_standard.destroy
    flash[:danger] = "Grading scheme has been deleted"
    redirect_to grading_standards_path
  end

  private
  def grading_standard_params
    params.required(:grading_standard).permit(:title, grading_scheme_attributes: [:name, :percentage])
  end
end
