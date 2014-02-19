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
            weather = {'city' => weatherinfo['weatherinfo']['city'], 'temp1' => weatherinfo['weatherinfo']['temp1'], 'index_d' => weatherinfo['weatherinfo']['index_d']}
            @temp = "#{weather['city']} #{weather['temp1']}"
            @temp_text = "#{weather['index_d']}"
            @long_temp_text = "#{weather['city']} #{weather['temp1']} #{weather['index_d']}"
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
