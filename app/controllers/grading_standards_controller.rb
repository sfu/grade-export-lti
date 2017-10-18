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
    uri = URI::HTTP.build(host: BASE_URL, path: "/api/v1/courses/3/grading_standards")
    params = {
        :title     => 'new gs 1004',
        :access_token => current_user.access_token,
        'grading_scheme_entry[][name]' => 'A+',
        'grading_scheme_entry[][value]' => '95',
        'grading_scheme_entry[][name]' => 'A',
        'grading_scheme_entry[][value]' => '90',
        'grading_scheme_entry[][name]' => 'A-',
        'grading_scheme_entry[][value]' => '85',
        'grading_scheme_entry[][name]' => 'B+',
        'grading_scheme_entry[][value]' => '80',
        'grading_scheme_entry[][name]' => 'B',
        'grading_scheme_entry[][value]' => '75',
        'grading_scheme_entry[][name]' => 'B-',
        'grading_scheme_entry[][value]' => '70',
        'grading_scheme_entry[][name]' => 'C+',
        'grading_scheme_entry[][value]' => '65',
        'grading_scheme_entry[][name]' => 'C',
        'grading_scheme_entry[][value]' => '60',
        'grading_scheme_entry[][name]' => 'C-',
        'grading_scheme_entry[][value]' => '55'
    }
    response = Net::HTTP.post_form(uri, params)
    json_response = JSON.parse(response.body)
    render plain: json_response

    # uri = URI::HTTP.build(host: BASE_URL, path: "/api/v1/courses/#{session[:course_id]}/grading_standards")
    # http = Net::HTTP.new(uri.host, uri.port)
    # request = Net::HTTP::Post.new(uri.request_uri, content_type: 'json')
    # logger.debug "#{request}"
    # request['Authorization'] = "Bearer #{current_user.access_token}"
    # request.body = {
    #     'title':'Some other GS',
    #     'grading_scheme_entry[][name]':'',
    #     'grading_scheme_entry[][value]': '',
    # }.to_json
    # response = http.request(request)
    # if response.code == NOT_AUTHORIZED
    #   redirect_to refresh_token_path
    # else
    #   render plain: "#{JSON.parse(response.body)}"
    # end
  end

  private
  def grading_standard_params
    params.required(:grading_standard).permit(:title, grading_scheme_attributes: [:name, :percentage])
  end
end
