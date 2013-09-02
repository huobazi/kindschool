class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :school_install?
  # check_authorization

  private
  def school_install?
    @subdomain =request.subdomain
    url_domain = request.domain
    if url_domain != "localhost.com" && WEBSITE_CONFIG["web_host"] != url_domain
      @aliases_url = url_domain
    end
  end

end
