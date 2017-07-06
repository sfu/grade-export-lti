module GradeExportHelper
  def extract_details(sis_course_id, option)
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
  end
end
