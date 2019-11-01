Rails.application.routes.draw do

  root 'lti#lti_get'

  resources :grading_standards
  resources :users

  get     '/lti',                  to: 'lti#lti_get'
  post    '/lti',                  to: 'lti#lti_post'
  get     '/lti/config',           to: 'lti#configuration', defaults: { format: 'xml' }

  get     '/oauth_start',          to: 'api_oauth#start'
  get     '/get_token',            to: 'api_oauth#get_token'
  get     '/logout',               to: 'api_oauth#logout'

  get     '/refresh_token',        to: 'api_oauth#refresh_token'

  get     '/:id',                  to: 'grade_export#course', as: 'course'
  get     '/courses/:id',          to: 'grade_export#grades', as: 'grades'
  get     '/export/:id',           to: 'grade_export#export', as: 'export'

  get     '/all_grades/:id',       to: 'grade_export#all_grades'

  post    '/apply_grading_scheme/:id', to: 'grading_standards#post_grading_standard', as: 'apply_grading_scheme'

end
