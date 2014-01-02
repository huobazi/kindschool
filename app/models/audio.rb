#encoding:utf-8
#资料音频表
class Audio < ActiveRecord::Base
  attr_accessible :audio_url, :kindergarten_id, :user_id
  belongs_to :kindergarten
  belongs_to :user
  before_save :generate_audio_url

  private
  def generate_audio_url
  	  if self.audio_url.blank?
  	     name ||= Digest::MD5.hexdigest("#{self.user.id}")
  	     self.audio_url = "/public/audios/"+"#{name}.mp3"
  	  end
  	  Sound.output_beep_url(self.user.name,self.audio_url)
  end
end
