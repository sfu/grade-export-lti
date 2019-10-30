class GradingStandardsController < ApplicationController
  before_action :authorize

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

  def post_grading_standard
    @grading_standard = current_user.grading_standards.find(params[:id])
    title = URI.escape(@grading_standard[:title])
    param_string = "title=#{title}&"

    @grading_standard.grading_scheme.each do |gs|
      param_string << "grading_scheme_entry[][name]=#{gs.name}&grading_scheme_entry[][value]=#{gs.percentage}&"
    end

    uri = URI::HTTPS.build(host: session[:canvas_url_base], path: "/api/v1/courses/#{session[:course_id]}/grading_standards", query: param_string)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE unless Rails.env.production?
    request = Net::HTTP::Post.new(uri)
    request['Authorization'] = "Bearer #{current_user.access_token}"
    response = http.request(request)

    flash[:success] = "Grading scheme has been successfully added to the course"
    redirect_to grading_standards_path #course_path(session[:course_id])
  end

  private
  def grading_standard_params
    params.required(:grading_standard).permit(:title, grading_scheme_attributes: [:name, :percentage])
  end
end
