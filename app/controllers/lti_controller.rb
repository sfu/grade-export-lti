class LtiController < ApplicationController
  protect_from_forgery

  def lti_get
    flash.now[:danger] = 'Opssss! This is not an LTI launch... Are you doing something wrong?!'
  end

  def lti_post
    nonce_isvalid     = valid_nonce?(request.request_parameters['oauth_nonce'], request.request_parameters['oauth_timestamp'])
    timestamp_isvalid = valid_timeStamp?(request.request_parameters['oauth_timestamp'])
    signature_isvalid = valid_lti_signature?

    if nonce_isvalid && timestamp_isvalid && signature_isvalid
      @request_params = request.request_parameters
    else
      flash.now[:danger] = 'Validation Failed'
      logger.debug "nonce is valid? #{nonce_isvalid}, timestamp is valid? #{timestamp_isvalid}, signature is valid? #{signature_isvalid}"
      render 'shared/error'
    end
    # authenticator = IMS::LTI::Services::MessageAuthenticator.new(request.url, request.request_parameters, "e074d7479a64c091bf3134da88f58230")
    # @request_params = request.request_parameters
    # @time_stamp_isvalid = ""
    # @oauth_timestamp = DateTime.strptime(request.request_parameters['oauth_timestamp'],'%s')
    # @signature_isvalid = authenticator.valid_signature?
    # if @oauth_timestamp < 5.minutes.ago
    #   @time_stamp_isvalid << "No"
    # else
    #   @time_stamp_isvalid << "Yes"
    # end
    # @request_params = request.request_parameters
    # @nonce_isvalid  = valid_nonce?(request.request_parameters['oauth_nonce'], request.request_parameters['oauth_timestamp'])
    # @timestamp_isvalid = valid_timeStamp?(request.request_parameters['oauth_timestamp'])
    # @signature_isvalid = valid_lti_signature?
  end

  def check_nonce
    render plain: "Nonce is valid? #{valid_nonce?(request.request_parameters['oauth_nonce'], request.request_parameters['oauth_timestamp'])}
                    Time Stamp is valid? #{valid_timeStamp?(request.request_parameters['oauth_timestamp'])}
                    Signature is valid? #{valid_lti_signature?}"
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
      timeStamp = DateTime.strptime(request.request_parameters['oauth_timestamp'],'%s')
      timeStamp > 5.minutes.ago
    rescue => error
      error.message
    end
  end

  def valid_lti_signature?
    authenticator = IMS::LTI::Services::MessageAuthenticator.new(request.url, request.request_parameters, "e074d7479a64c091bf3134da88f582301")
    authenticator.valid_signature?
  end

end
