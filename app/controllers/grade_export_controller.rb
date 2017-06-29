class GradeExportController < ApplicationController
  before_action :logged_in_user, only: [:show]
  before_action :correct_user,   only: [:show]

  def courses
    parameters = {
        :access_token => current_user.access_token
    }
    #path for enrollments: /api/v1/courses/3/enrollments
    uri = URI::HTTP.build(host: 'web.canvaslms.docker', path: '/api/v1/courses/', query: parameters.to_query)
    response = Net::HTTP.get_response(uri)
    @json_response = JSON.parse(response.body)
    # render plain: @json_response
  end

  def grades
    parameters = {
        :access_token => current_user.access_token
    }
    #path for enrollments: /api/v1/courses/3/enrollments
    uri = URI::HTTP.build(host: 'web.canvaslms.docker', path: "/api/v1/courses/#{params[:id]}/enrollments", query: parameters.to_query)
    response = Net::HTTP.get_response(uri)
    @json_response = JSON.parse(response.body)
  end

  def export
  end
end
