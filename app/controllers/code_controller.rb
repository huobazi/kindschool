class CodeController < ApplicationController
  def code_image
    image = session[:noisy_image].code_image
    send_data image, :type => 'image/gif', :disposition => 'inline'
  end

  def recode
    code_size = rand(3) + 4
    session[:noisy_image] = NoisyImage.new(code_size)
    session[:code] = session[:noisy_image].code
    render :text=>"ok"
  end
end
