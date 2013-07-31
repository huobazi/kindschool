class CodeController < ApplicationController
  def code_image
    image = session[:noisy_image].code_image
    send_data image, :type => 'image/gif', :disposition => 'inline'
  end
end
