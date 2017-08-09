module ApiOauthHelper
  def token_has_expired?
    current_user.token_expires_at.nil? ? true : current_user.token_expires_at < DateTime.now
  end
end
