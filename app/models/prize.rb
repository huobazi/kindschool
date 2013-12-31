#encoding:utf-8
#奖品表
class Prize < ActiveRecord::Base
  attr_accessible :beep, :beep_url, :content, :content_url, :name, :status
  mount_uploader :content_url, ContentUrlUploader
  before_save :generate_beep_url
  private
  def generate_beep_url
  	if self.beep_changed?
  	  if self.beep_url.blank?
         name ||= Digest::MD5.hexdigest("#{Time.now.to_i.to_s}")
  	     self.beep_url = "prizes/"+"#{name}.mp3"
  	  end
  	   Sound.output_beep_url(self.beep,self.beep_url)
    end
  end

end
