Rails.application.routes.draw do

  get 'api_oauth/start'

  get 'api_oauth/exchange_code_token'

  get 'api_oauth/logout'

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

  get     '/oauth-start',     to: 'api_oauth#start'
  get     '/get-token',       to: 'api_oauth#get_token'
  get     '/logout',          to: 'api_oauth#logout'

  get     '/canvas_api_get',  to: 'api_oauth#canvas_api_get'
  get     '/refresh-token',   to: 'api_oauth#refresh_token'

  resources :users
end
