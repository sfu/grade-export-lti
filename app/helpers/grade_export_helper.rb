module GradeExportHelper
  def extract_details(sis_course_id, option)
    begin
      course_details = sis_course_id.split('-')
      case option
        when CourseDetail::TERM
          return course_details[CourseDetail::TERM]
        when CourseDetail::SUBJECT
          return course_details[CourseDetail::SUBJECT]
        when CourseDetail::NUMBER
          return course_details[CourseDetail::NUMBER]
        when CourseDetail::SECTION
          return course_details[CourseDetail::SECTION]
      end
    rescue => e
      logger.debug "sis_course_id is null or has wrong format sis_course_id: #{sis_course_id}"
      flash.now[:danger] = 'sis_course_id is null or has wrong format, as a result, course and section fields will not be displayed'
      render template: 'shared/error'
    end
  end
end
