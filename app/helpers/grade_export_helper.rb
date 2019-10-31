module GradeExportHelper
  def extract_details(sis_section_id, option)
    begin
      course_details = sanitise_sis_id(sis_section_id)

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
      flash.now[:danger] = 'sis_course_id is null or has wrong format, as a result, course and section fields will not be displayed'
      render template: 'shared/error'
    end
  end

  def sanitise_sis_id(str)
    # String input format: ####-aaaa-###-a###:::###########
    str.split(':::')[0].split('-')
  end
end
