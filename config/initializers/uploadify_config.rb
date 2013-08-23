Uploadify::Rails.configure do |config|
  config.uploader        = "/my_school/albums/add_entry_imgs"
  config.buttonText      = lambda { I18n.t('uploader.upload_file') }
  config.queueID         = 'uploadify_queue_div'
  config.onUploadSuccess = true
end