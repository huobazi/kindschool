#encoding:utf-8
require 'net/http'
require 'net/https'
require 'uri'
require 'open-uri'
class WeixinToken < ActiveRecord::Base
  attr_accessible :number,:appid, :secret, :access_token, :expires_in, :expires_at

  #获取token
  def get_access_token(load_token=false)
    if !appid.blank? && !secret.blank?
      if (Time.now.to_i - expires_at.to_i > expires_in) || load_token
        opt = {:grant_type => "client_credential", :appid =>self.appid ,:secret =>self.secret }
        url = URI.parse(WEBSITE_CONFIG["weixin_token_url"])
        begin
          url.query = URI.encode_www_form(opt)
          response = WeixinToken.http_get(url, opt)
          if (200..210).include?(response.code.to_i)
            data = JSON(response.body)
            self.update_attributes!(:access_token=>data["access_token"],:expires_in=>data["expires_in"]||0,:expires_at=>Time.now) if data["errcode"].blank?
          end
          return "error"
        rescue Exception => e
          p e.message
          return "error"
        end
      end
    end
    return (Time.now.to_i - expires_at.to_i < expires_in) ? access_token : nil
  end

  def down_media(media_id)
    if token = get_access_token
      opt = {:access_token => token, :media_id => media_id }
      url = URI.parse(WEBSITE_CONFIG["weixin_media_down_url"])
      begin
        url.query = URI.encode_www_form(opt)
        auto_url = "/audios/weixin/#{Time.now.to_i}-#{media_id}"
        file_patch =  "#{Rails.root}/public#{auto_url}.amr"
        file_turn_patch =  "#{Rails.root}/public#{auto_url}.mp3"
        open(url) do |http|
          File.open(file_patch,'wb') do |f|
            f.syswrite(http.read)
          end
        end
        `ffmpeg -i #{file_patch} #{file_turn_patch}`
        return auto_url
      rescue Exception => e
        p e.message
        return "error"
      end
    end
  end
  

  private
  #发起get请求
  def self.http_get(url,json_data,username="",password="")
    http = Net::HTTP
    req = http::Get.new(url.request_uri)
    self.call_cloud(http,req,url,json_data,username,password)
  end

  def self.http_put(url, json_data, username="", password="")
    http = Net::HTTP
    req = http::Put.new(url.path)
    self.call_cloud(http, req, url, json_data, username, password)
  end
  #发起请求，post
  #参数：url和参数
  def self.http_post(url,json_data,username="",password="")
    http = Net::HTTP
    req = http::Post.new(url.path)
    #    puts "Contacting #{url.scheme}://#{url.host}"
    self.call_cloud(http,req,url,json_data,username,password)
  end
  
  def self.call_cloud(http,req,url,json_data,username,password)
    #    puts "Contacting #{url.scheme}://#{url.host}"
    #    req.set_form_data(json_data)
    http = http.new(url.host, url.port)
    req.basic_auth username,password if !username.blank? && !password.blank?
    if url.scheme == "https"
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    end
    response = http.start {|con| con.request(req)}
  end
end
