#encoding:utf-8
#短信
require 'digest/sha1'
require 'net/http'
require 'uri'
class ShortMessage
  #发送短信
  #phone，接收的号码，可发送多个，使用“,”号隔开，长度不能超过2000
  #msg，发送的内容，长度不能超过603，中文字符计数为1。内容如果超过，需自己裁切。
  #expid，扩展号，上行时可以使用
  #return #=> 发送的消息的id号
  #出错    #=> "error"
  def self.send_sms(phone,msg,expid)
    url = URI.parse(SMS_CONFIG['send_url'])
    raise "send sms : phone is blank." if phone.blank?
    raise "send sms : msg is blank." if msg.blank?
    begin
      opt = {:uid => SMS_CONFIG["uid"],:encode=>SMS_CONFIG["encode"],  :auth => self.get_validate_key,:mobile => phone,:msg=>msg.encode("GBK"),:expid=>expid,:time=>""}#Time.now.to_all_datetime
      response = self.http_post(url, opt)
      if (200..210).include?(response.code.to_i)
        data = response.body.split(",")
        if data[0] == "0"
          return data[1]
        end
      end
      return "error"
    rescue Exception => e
      p e.message
      return "error"
    end
  end

  #获取上行短信数据
  #最快每30秒获取一次
  #return #=>["2013-06-28 14:54:57.0##0##18938681985##看看就看看","2013-06-28 14:54:57.0##0##18938681985##看看就看看"]
  #异常时返回  #=>"error"
  def self.get_sms_data
    url = SMS_CONFIG['get_url']
    begin
      opt = {:uid => SMS_CONFIG["uid"], :auth => self.get_validate_key}
      response = self.http_get(url, opt)
      if (200..210).include?(response.code.to_i)
        body =URI::unescape(response.body.to_s).force_encoding("GBK").encode("utf-8")
        data = body.split("\n")
        sms_count = data.shift.to_i
        if sms_count >= 0
          return data
        end
      end
      return "error"
    rescue Exception => e
      p e.message
      return "error"
    end
  end

  #获取余额
  #最快每5分钟获取一次
  #return #=>"100"
  #出错    #=>"error"
  def self.get_balance
    url = URI.parse(SMS_CONFIG['get_balance_url'])
    begin
      opt = {:uid => SMS_CONFIG["uid"], :auth => self.get_validate_key}
      response = self.http_get(url, opt)
      if (200..210).include?(response.code.to_i)
        data = response.body
        return data
      end
      return "error"
    rescue Exception => e
      p e.message
      return "error"
    end
  end

  
  private
  #参数：url和参数
  def self.http_post(url,json_data)
    http = Net::HTTP
    req = http::Post.new(url.path)
    puts "Contacting #{url.scheme}://#{url.host}"
    req.set_form_data(json_data)
    http = http.new(url.host, url.port)
    response = http.start {|con| con.request(req)}
  end

  #发起get请求
  def self.http_get(url,json_data)
    params = ""
    unless json_data.blank?
      data = []
      json_data.each do |k,v|
        data << "#{k}=#{v}"
      end
      params = "?#{data.join("&")}"
    end
    url = URI.parse("#{url}#{params}")
    site = Net::HTTP.new(url.host, url.port)
    path = url.query.blank? ? url.path : url.path+"?"+url.query
    puts "Contacting #{url.scheme}://#{url.host}?#{url.query}====="
    response =site.get2(path)
  end

  #验证
  def self.get_validate_key
    return Digest::MD5.hexdigest("#{SMS_CONFIG["login"]}#{SMS_CONFIG["password"]}").downcase
  end
end
