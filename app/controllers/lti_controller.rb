class LtiController < ApplicationController

  skip_before_action :verify_authenticity_token

  def lti_get
    flash.now[:danger] = 'Opssss! This is not an LTI launch.'
  end

  def lti_post
    nonce_isvalid     = valid_nonce?(request.request_parameters['oauth_nonce'], request.request_parameters['oauth_timestamp'])
    timestamp_isvalid = valid_timeStamp?(request.request_parameters['oauth_timestamp'])
    signature_isvalid = valid_lti_signature?(request.url, request.request_parameters, Rails.application.secrets.lti_secret)

    if nonce_isvalid && timestamp_isvalid && signature_isvalid
      @user = user_exists?(request.request_parameters['lis_person_contact_email_primary'])

      if @user
        login_user(@user, "Hello #{@user.name}, Welcome back to the Grade Export App!")
      else
        random_secure_string = SecureRandom.hex(10)
        @request_params = request.request_parameters
        @user = User.new(name:request.request_parameters['lis_person_name_full'],
                         email:request.request_parameters['lis_person_contact_email_primary'],
                         password: random_secure_string,
                         password_confirmation: random_secure_string)
        if @user.save
          login_user(@user, "Hello #{@user.name}, Welcome to the Grade Export App!")
        else
          flash.now[:danger] = 'Oooops!..... Could not create user!'
          logger.debug @user.errors.full_messages
          render 'shared/error'
          #render 'users/new'
        end
      end
    else
      flash.now[:danger] = 'LTI Validation Failed'
      logger.debug "nonce is valid? #{nonce_isvalid}, timestamp is valid? #{timestamp_isvalid}, signature is valid? #{signature_isvalid}"
      render 'shared/error'
    end

  end

  private

  def valid_nonce?(nonce, timeStamp)
    keep_for_90_min = 90 * 60
    begin
      if nonce.empty?
        false
      elsif $redis.get(nonce).nil?
        $redis.setex(nonce, keep_for_90_min, timeStamp)
        true
      else
        false
      end
    rescue => e
      logger.debug "#{e.message}"
      false
    end
  end

  def valid_timeStamp?(timeStampString)
    begin
      timeStamp = DateTime.strptime(timeStampString,'%s')
      timeStamp > 5.minutes.ago
    rescue => error
      error.message
    end
  end

  def valid_lti_signature?(launch_url, params, secret)
    authenticator = IMS::LTI::Services::MessageAuthenticator.new(launch_url, params, secret)
    authenticator.valid_signature?
  end

  def user_exists?(email)
    @user = User.find_by(email: email)
  end

  def login_user(user, message)
    session[:user_id] = user.id
    flash[:success] = message
    redirect_to user
  end

end
