class GradeExportController < ApplicationController
  before_action :authorize

  def courses
    @courses = response_for_2('/api/v1/courses/')
  end

  def grades
    @enrollments = response_for_2("/api/v1/courses/#{params[:id]}/enrollments")
  end

  # def all_grades
  #   @assignments = {}
  #   @student_submissions = {}
  #   courses = response_for('/api/v1/courses/').map {|course| OpenStruct.new(course)}
  #   courses.each do |course|
  #     students = response_for("/api/v1/courses/#{course.id}/students").map {|student| OpenStruct.new(student)}.each do |student|
  #       @student_submissions[student.sis_user_id] = {}
  #     end
  #     logger.debug "/api/v1/courses/#{course.id}/assignments"
  #     response_for("/api/v1/courses/#{course.id}/assignments").map {|assignment| OpenStruct.new(assignment)}.each do |assignment|
  #       submissions = {}
  #       response_for("/api/v1/courses/#{course.id}/assignments/#{assignment.id}/submissions").map {|submission| OpenStruct.new(submission)}.each do |submission|
  #         idx = students.index {|s| s.id.to_i == submission.user_id.to_i}
  #         student_sis_id = idx ? students[idx].sis_user_id : nil
  #         student_name = idx ? students[idx].name : nil
  #         submissions[submission.id] = {
  #             'user_id'            => submission.user_id,
  #             'course_name'        => course.name,
  #             'student_name'       => student_name,
  #             'student_sis_id'     => student_sis_id,
  #             'assignment_name'    => assignment.name,
  #             'grade'              => submission.grade
  #         }
  #         logger.debug "student number: #{student_sis_id}: #{assignment.name} => #{submission.grade}"
  #         @student_submissions[student_sis_id].merge!({
  #             assignment.name => submission.grade
  #         })
  #         logger.debug "#{@student_submissions}"
  #       end
  #       @assignments[assignment.name] = submissions
  #       logger.debug "------------------------------------------------------"
  #     end
  #     logger.debug "***** #{@student_submissions}"
  #   end
  # end
  def all_grades
    @assignments = {}
    @student_submissions = {}
      students = response_for("/api/v1/courses/#{params[:id]}/students").map {|student| OpenStruct.new(student)}.each do |student|
        @student_submissions[student.sis_user_id] = {}
      end
      response_for("/api/v1/courses/#{params[:id]}/assignments").map {|assignment| OpenStruct.new(assignment)}.each do |assignment|
        submissions = {}
        response_for("/api/v1/courses/#{params[:id]}/assignments/#{assignment.id}/submissions").map {|submission| OpenStruct.new(submission)}.each do |submission|
          idx = students.index {|s| s.id.to_i == submission.user_id.to_i}
          student_sis_id = idx ? students[idx].sis_user_id : nil
          student_name = idx ? students[idx].name : nil
          @student_submissions[student_sis_id].merge!({
                                                          assignment.name => submission.grade,
                                                      })
        end
        @assignments[assignment.name] = submissions
      end
  end

  def export
    @enrollments = response_for_2("/api/v1/courses/#{params[:id]}/enrollments")
    respond_to do |format|
      format.html
      format.xlsx {
        response.headers['Content-Disposition'] = 'attachment; filename="Final_Grades.xlsx"'
      }
    end
  end

  private

  # Includes access_token in the POST
  def response_for(path)
    parameters = {
        :access_token => current_user.access_token
    }
    #path for enrollments: /api/v1/courses/3/enrollments
    uri = URI::HTTP.build(host: 'web.canvaslms.docker', path: path, query: parameters.to_query)
    response = Net::HTTP.get_response(uri)
    if response.code == NOT_AUTHORIZED
      redirect_to current_user
    else
      JSON.parse(response.body)
    end
  end

  # Includes the access_token in the Request Header - better practice according to Canvas LMS documentation
  def response_for_2(path)
    uri = URI::HTTP.build(host: 'web.canvaslms.docker', path: path)
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Get.new(uri.request_uri)
    logger.debug "#{request}"
    request['Authorization'] = "Bearer #{current_user.access_token}"
    response = http.request(request)
    if response.code == NOT_AUTHORIZED
      redirect_to current_user
    else
      JSON.parse(response.body)
    end
  end

end
