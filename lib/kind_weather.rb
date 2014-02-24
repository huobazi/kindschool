#encoding:utf-8
module KindWeather
  protected

  def cache_weather(kind)
    if kind.kind_zone
      today,new_today = Redis::Objects.redis.get("#{kind.kind_zone.code}_today"),false
      if today
        today_time = Time.parse(today)
        if today_time.to_date == Time.now.to_date
          new_today = true
        end
      end
      if new_today
        @temp = Redis::Objects.redis.get("#{kind.kind_zone.code}_temp")
        @temp_text = Redis::Objects.redis.get("#{kind.kind_zone.code}_temp_text")
        @long_temp_text = Redis::Objects.redis.get("#{kind.kind_zone.code}_long_temp_text")
      else
        begin
          weatherinfo = JSON.parse(open("http://m.weather.com.cn/data/#{kind.kind_zone.code}.html").read)
          if weatherinfo && weatherinfo['weatherinfo']
            date_y = weatherinfo['weatherinfo']['date_y']
            date_count = (Time.now.to_date - DateTime.strptime(date_y,'%Y年%m月%d日').to_date).to_i
            temp = "temp#{date_count + 1}"
            weather_prompt = "weather#{date_count + 1}"
            weather = {'city' => weatherinfo['weatherinfo']['city'], 'temp1' => weatherinfo['weatherinfo'][temp], 'index48_d' => weatherinfo['weatherinfo']['index48_d'], 'weather_prompt' => weatherinfo['weatherinfo'][weather_prompt]}
            @temp = "#{weather['city']} #{weather['temp1']} #{weather['weather_prompt']}"
            @temp_text = "#{weather['index48_d']}"
            @long_temp_text = "#{weather['city']} #{weather['temp1']} #{weather['weather_prompt']} #{weather['index48_d']}"
            Redis::Objects.redis.set("#{kind.kind_zone.code}_temp", @temp)
            Redis::Objects.redis.set("#{kind.kind_zone.code}_temp_text", @temp_text)
            Redis::Objects.redis.set("#{kind.kind_zone.code}_long_temp_text", @long_temp_text)
            Redis::Objects.redis.set("#{kind.kind_zone.code}_today", Time.now)
          end
        rescue Exception => e
        end
      end
    end
  end

end
