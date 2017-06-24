class LtiController < ApplicationController
  skip_before_action :verify_authenticity_token

  def lti_get
    flash.now[:danger] = 'Opssss! This is not an LTI launch... Are you doing something wrong?!'
  end

  def lti_post
    nonce_isvalid     = valid_nonce?(request.request_parameters['oauth_nonce'], request.request_parameters['oauth_timestamp'])
    timestamp_isvalid = valid_timeStamp?(request.request_parameters['oauth_timestamp'])
    signature_isvalid = valid_lti_signature?(request.url, request.request_parameters, "e074d7479a64c091bf3134da88f582301")

    if nonce_isvalid && timestamp_isvalid && signature_isvalid
      @user = user_exists?(request.request_parameters['lis_person_contact_email_primary'])

      if @user
        session[:user_id] = @user.id
        flash[:success] = "Hello #{@user.name}, Welcome to the Grade Export App!"
        redirect_to @user
      else
        random_secure_string = SecureRandom.hex(10)
        @request_params = request.request_parameters
        @user = User.new(name:request.request_parameters['lis_person_name_full'],
                         email:request.request_parameters['lis_person_contact_email_primary'],
                         password: random_secure_string,
                         password_confirmation: random_secure_string)
        if @user.save
          # log_in @user
          logger.info "User id ******************** #{@user.id}"
          session[:user_id] = @user.id
          flash[:success] = "Welcome to the Grade Export App!"
          redirect_to @user
        else
          render 'users/new'
        end
      end
    else
      flash.now[:danger] = 'LTI Validation Failed'
      logger.debug "nonce is valid? #{nonce_isvalid}, timestamp is valid? #{timestamp_isvalid}, signature is valid? #{signature_isvalid}"
      render 'shared/error'
    end

  end

  def check_nonce
    render plain: "Nonce is valid? #{valid_nonce?(request.request_parameters['oauth_nonce'], request.request_parameters['oauth_timestamp'])}
                    Time Stamp is valid? #{valid_timeStamp?}
                    Signature is valid? #{valid_lti_signature?}"
  end

  def generate_string
    render plain: "Secure Random is: #{SecureRandom.hex(10)}, user is: #{user_exists?(request.request_parameters['lis_person_contact_email_primary'])}"
  end

  private

  def valid_nonce?(nonce, timeStamp)
    keep_for_90_min = 90 * 60
    if nonce.empty?
      false
    elsif $redis.get(nonce).nil?
      $redis.setex(nonce, keep_for_90_min, timeStamp)
      true
    else
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

end
