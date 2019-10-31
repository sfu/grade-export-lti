require 'net/http'

class ApiOauthController < ApplicationController

  before_action :authorize

  def redirect_uri
    dc = Rails.configuration.domain
    scheme = dc['secure'] ? 'https' : 'http'
    "#{scheme}://#{dc['domain']}/get_token"
  end

  def start
    parameters = {
        client_id: Rails.application.secrets.api_client_id,
        response_type: 'code',
        redirect_uri: redirect_uri,
    }
    uri = URI.parse("#{session[:canvas_url_base]}/login/oauth2/auth?#{parameters.to_query}").to_s
    redirect_to uri
  end

  def get_token
    uri = URI.parse("#{session[:canvas_url_base]}/login/oauth2/token")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true if uri.scheme == 'https'
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE unless Rails.env.production?
    req = Net::HTTP::Post.new(uri.request_uri)
    req.add_field('Content-Type', 'application/json')
    req.body = {
        :client_id      => Rails.application.secrets.api_client_id,
        :client_secret  => Rails.application.secrets.api_client_secret,
        :redirect_uri   => redirect_uri,
        :code           => request.query_parameters['code'],
    }.to_json
    response = http.request(req)
    
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
    uri = URI.parse("#{session[:canvas_url_base]}/login/oauth2/token")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true if uri.scheme == 'https'
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE unless Rails.env.production?
    request = Net::HTTP::Post.new(uri.request_uri)
    request.add_field('Content-Type', 'application/json')
    request.body = {
        :grant_type     => 'refresh_token',
        :client_id      => Rails.application.secrets.api_client_id,
        :client_secret  => Rails.application.secrets.api_client_secret,
        :refresh_token  => current_user.refresh_token,
    }.to_json
    response = http.request(request)
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
    uri = URI::HTTP.build(host: session[:canvas_url_base], path: '/api/v1/login/oauth2/token')
    params = {:_method      => 'DELETE',
              :access_token => current_user.access_token,
    }
    response = Net::HTTP.post_form(uri, params)
    json_response = JSON.parse(response.body)

    render plain: json_response
  end

end
