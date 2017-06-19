class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper

  def main
    render plain: "This is the main page of this app"
  end
end
