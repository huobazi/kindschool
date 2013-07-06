class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :school_install?
  # check_authorization
  
  private
  def school_install?
    @subdomain =request.subdomain
  end

end
