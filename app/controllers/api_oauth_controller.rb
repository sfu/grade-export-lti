class ApiOauthController < ApplicationController
  # before_action :logged_in_user, only: [:show]
  # before_action :correct_user,   only: [:show]
  before_action :authorize

  def start
    # uri = 'http://web.canvaslms.docker/login/oauth2/auth?client_id=10000000000003&response_type=code&redirect_uri=http://0.0.0.0:3001/get-token'
    parameters = {
        client_id: '10000000000003',
        response_type: 'code',
        redirect_uri: 'http://0.0.0.0:3001/get_token'
    }
    uri = URI::HTTP.build(host: 'web.canvaslms.docker', path: '/login/oauth2/auth', query: parameters.to_query).to_s
    redirect_to uri
  end

  def get_token
    uri = URI::HTTP.build(host: 'web.canvaslms.docker', path: '/login/oauth2/token')
    params = {
        :client_id      => '10000000000003',
        :redirect_uri   => 'http://0.0.0.0:3001/get_token',
        :client_secret  => 'NlGNuLRz9g3fxHQ3jDR4SA4TK8jW39KfHXvwstaO5Am9Gi8rtyLBHXeB7Aw0DcMj',
        :code           => request.query_parameters['code'],
    }
    response = Net::HTTP.post_form(uri, params)
    json_response = JSON.parse(response.body)

    current_user.update_attribute(:access_token, json_response['access_token'])
    current_user.update_attribute(:refresh_token, json_response['refresh_token'])

    redirect_to courses_path
    #redirect_to current_user
    # render plain: "Access Token is: #{json_response['access_token']}
    #                 #{json_response}"
  end

  def refresh_token
    uri = URI::HTTP.build(host: 'web.canvaslms.docker', path: '/login/oauth2/token')
    params = {
        :grant_type     => 'refresh_token',
        :client_id      => '10000000000003',
        :client_secret  => 'NlGNuLRz9g3fxHQ3jDR4SA4TK8jW39KfHXvwstaO5Am9Gi8rtyLBHXeB7Aw0DcMj',
        :refresh_token  => current_user.refresh_token,
    }
    response = Net::HTTP.post_form(uri, params)
    json_response = JSON.parse(response.body)

    current_user.update_attribute(:access_token, json_response['access_token'])

    render plain: json_response
  end

  def logout
    uri = URI.parse('http://web.canvaslms.docker/login/oauth2/token')
    params = {:_method      => 'DELETE',
              :access_token => current_user.access_token,
    }
    response = Net::HTTP.post_form(uri, params)
    json_response = JSON.parse(response.body)

    render plain: json_response
  end

end
