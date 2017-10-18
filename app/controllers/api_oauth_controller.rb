class ApiOauthController < ApplicationController

  before_action :authorize

  def start
    parameters = {
        client_id: Rails.application.secrets.api_client_id,
        response_type: 'code',
        redirect_uri: GET_TOKEN_ENDPOINT,
        # scope:'/auth/userinfo'
    }
    uri = URI::HTTP.build(host: BASE_URL, path: '/login/oauth2/auth', query: parameters.to_query).to_s
    redirect_to uri
  end

  def get_token
    uri = URI::HTTP.build(host: BASE_URL, path: '/login/oauth2/token')
    params = {
        :client_id      => Rails.application.secrets.api_client_id,
        :client_secret  => Rails.application.secrets.api_client_secret,
        :redirect_uri   => GET_TOKEN_ENDPOINT,
        :code           => request.query_parameters['code'],
    }
    response = Net::HTTP.post_form(uri, params)
    json_response = JSON.parse(response.body)

    current_user.update_columns(
                :access_token     => json_response['access_token'],
                :refresh_token    => json_response['refresh_token'],
                :token_expires_at => DateTime.now + 59.minutes, )
    #current_user.update_attribute(:access_token, json_response['access_token']) unless json_response['access_token'].nil?
    #current_user.update_attribute(:refresh_token, json_response['refresh_token']) unless json_response['refresh_token'].nil?

    redirect_to course_path(session[:course_id])
  end

  def refresh_token
    uri = URI::HTTP.build(host: BASE_URL, path: '/login/oauth2/token')
    params = {
        :grant_type     => 'refresh_token',
        :client_id      => Rails.application.secrets.api_client_id,
        :client_secret  => Rails.application.secrets.api_client_secret,
        :refresh_token  => current_user.refresh_token,
    }
    response = Net::HTTP.post_form(uri, params)
    json_response = JSON.parse(response.body)

    if json_response['error'] == 'invalid_request'
      redirect_to oauth_start_path
    else
      current_user.update_columns(
          :access_token     => json_response['access_token'],
          :token_expires_at => DateTime.now + 59.minutes, )
      redirect_to course_path(session[:course_id])
    end
  end

  def logout
    uri = URI::HTTP.build(host: BASE_URL, path: '/api/v1/login/oauth2/token')
    params = {:_method      => 'DELETE',
              :access_token => current_user.access_token,
    }
    response = Net::HTTP.post_form(uri, params)
    json_response = JSON.parse(response.body)

    render plain: json_response
  end

end
