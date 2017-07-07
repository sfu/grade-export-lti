class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper

  def main
    render plain: "This is the main page of this app"
  end

  def authorize
    if(!current_user)
      flash[:danger] = "You are not authorized to access this page"
    end
    redirect_to root_path unless current_user
  end
end
