class ApiOauthController < ApplicationController
  def start
    # uri = 'http://web.canvaslms.docker/login/oauth2/auth?client_id=10000000000003&response_type=code&redirect_uri=http://0.0.0.0:3001/get-token'
    parameters = {
        client_id: '10000000000003',
        response_type: 'code',
        redirect_uri: 'http://0.0.0.0:3001/get-token'
    }
    uri = URI::HTTP.build(host: 'web.canvaslms.docker', path: '/login/oauth2/auth', query: parameters.to_query).to_s
    redirect_to uri
  end

  def get_token
    uri = URI::HTTP.build(host: 'web.canvaslms.docker', path: '/login/oauth2/token')
    params = {
        :client_id      => '10000000000003',
        :redirect_uri   => 'http://0.0.0.0:3001/get-token',
        :client_secret  => 'NlGNuLRz9g3fxHQ3jDR4SA4TK8jW39KfHXvwstaO5Am9Gi8rtyLBHXeB7Aw0DcMj',
        :code           => request.query_parameters['code'],
    }
    response = Net::HTTP.post_form(uri, params)
    json_response = JSON.parse(response.body)

    #@access_token = request.query_parameters['access_token']
    current_user.update_attribute(:access_token, json_response['access_token'])

    render plain: "Access Token is: #{json_response['access_token']}
                    #{json_response}
                    current user is: #{current_user.name}"
  end

  def refresh_token
    uri = URI::HTTP.build(host: 'web.canvaslms.docker', path: '/login/oauth2/token')
    params = {
        :grant_type     => 'refresh_token',
        :client_id      => '10000000000003',
        :client_secret  => 'NlGNuLRz9g3fxHQ3jDR4SA4TK8jW39KfHXvwstaO5Am9Gi8rtyLBHXeB7Aw0DcMj',
        :refresh_token  => 'sahzvKe3PawVX02cC3qMWvTCCbn7EHqVUt9VJE8b3eUGsdCNZPmNhZHOshT1vE5O',
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

  # ****************************************
  def canvas_api_get
    parameters = {
        :access_token => current_user.access_token
    }
    uri = URI::HTTP.build(host: 'web.canvaslms.docker', path: '/api/v1/courses/3/enrollments', query: parameters.to_query)
    response = Net::HTTP.get_response(uri)
    json_response = JSON.parse(response.body)
    render plain: json_response

    #render plain: "the url is: #{uri}"
  end
  # ****************************************


end
