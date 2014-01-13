School::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # Code is not reloaded between requests
  config.cache_classes = true

  # Full error reports are disabled and caching is turned on
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # Disable Rails's static asset server (Apache or nginx will already do this)
  config.serve_static_assets = true

  # Compress JavaScripts and CSS
  config.assets.compress = true

  # Don't fallback to assets pipeline if a precompiled asset is missed
  config.assets.compile = false

  # Generate digests for assets URLs
  config.assets.digest = true

  # Defaults to nil and saved in location specified by config.assets.prefix
  # config.assets.manifest = YOUR_PATH

  # Specifies the header that your server uses for sending files
  # config.action_dispatch.x_sendfile_header = "X-Sendfile" # for apache
  # config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect' # for nginx

  # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
  # config.force_ssl = true

  # See everything in the log (default is :info)
  # config.log_level = :debug

  # Prepend all log lines with the following tags
  # config.log_tags = [ :subdomain, :uuid ]

  # Use a different logger for distributed setups
  # config.logger = ActiveSupport::TaggedLogging.new(SyslogLogger.new)

  # Use a different cache store in production
  # config.cache_store = :mem_cache_store

  # Enable serving of images, stylesheets, and JavaScripts from an asset server
  # config.action_controller.asset_host = "http://assets.example.com"

  # Precompile additional assets (application.js, application.css, and all non-JS/CSS are already added)
  # config.assets.precompile += %w( search.js )
  # Disable delivery errors, bad email addresses will be ignored
#  config.action_mailer.raise_delivery_errors = false
  config.action_mailer.default_url_options = { :host => 'www.weiyizixun.com' }
  # Enable threaded mode
  # config.threadsafe!

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation can not be found)
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners
  config.active_support.deprecation = :notify
  config.assets.initialize_on_precompile = false
  # Log the query plan for queries taking more than this (works
  # with SQLite, MySQL, and PostgreSQL)
  # config.active_record.auto_explain_threshold_in_seconds = 0.5
  config.assets.precompile += %w(shop_center.css credit_shop.css app_bootstrap.css colorful.css flowers.css jquery.rater.css weiyi.css fancybox/*.css fancybox/*.js datepicker.css colorful.js rails.validations.js rails.validations.simple_form.js bootstrap-datepicker.js bootstrap-datepicker.zh-CN.js jquery.rater.js colorful_main.css flowers_main.css colorful_main.js colorful_weixin.css colorful_responsive.css scaffolds.css active_admin.css colorful_weixin.js jquery.jcarouselLite.js jquery.validate.js DD_belatedPNG.js jquery.timers.js  css/*.css js/banner.js js/jquery.timelinr-0.9.53.js jquery.lettering.js rails.validations.customValidators.js uploadify.js uploadify-rails.js jquery.opacityrollover.js jquery.galleriffic.js galleriffic.css highcharts/highcharts.js highcharts/highcharts-more.js garden.css plupload.full.min.js)
  #jquery.slideViewerPro.js svwp_style.css
end
