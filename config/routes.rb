Rails.application.routes.draw do

  root 'static_pages#home'

  get     '/help',            to: 'static_pages#help'
  get     '/about',           to: 'static_pages#about'
  get     '/contact',         to: 'static_pages#contact'

  get     '/signup',          to: 'users#new'
  post    '/signup',          to: 'users#create'


  get     '/login',           to: 'sessions#new'
  post    '/login',           to: 'sessions#create'
  delete  '/logout',          to: 'sessions#destroy'

  get     '/lti',             to: 'lti#lti_get'
  post    '/lti',             to: 'lti#lti_post'

  post    '/check-nonce',     to: 'lti#check_nonce'

  get     '/generate-string', to: 'lti#generate_string'
  post    '/generate-string', to: 'lti#generate_string'

  get     '/oauth_start',     to: 'api_oauth#start'
  get     '/get_token',       to: 'api_oauth#get_token'
  get     '/logout',          to: 'api_oauth#logout'

  get     '/canvas_api_get',  to: 'api_oauth#canvas_api_get'
  get     '/canvas_api_post', to: 'api_oauth#canvas_api_post'
  get     '/refresh-token',   to: 'api_oauth#refresh_token'

  get     '/courses',         to: 'grade_export#courses'
  get     '/courses/:id',     to: 'grade_export#grades', as: 'grades'
  get     '/export/:id',      to: 'grade_export#export', as: 'export'

  #get 'grade_export/export'

  resources :users
end
