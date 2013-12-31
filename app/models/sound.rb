#encoding:utf-8
#mp3
class Sound
  def self.output_sound(user,tp,prize)
    `ekho "#{user.name}小朋友,你获得的奖品是#{prize}"   -o "#{Rails.root}/mp3/#{user.name}.mp3`
  end
end