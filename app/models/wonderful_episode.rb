#encoding:utf-8
# 精彩视频
# title: 标题
# url_address: url地址
# is_top :是否置顶
class WonderfulEpisode < ActiveRecord::Base
  attr_accessible :is_top, :kindergarten_id, :squad_id, :title, :url_address, :user_id

  validates :kindergarten_id, :url_address, :title, :presence => true
  validate :correct_url_address_format

  belongs_to :kindergarten
  belongs_to :squad
  belongs_to :creater, :class_name => "User", :foreign_key => "user_id"

  default_scope order("is_top DESC, created_at DESC")

  include UnreadComment

  # key为视频编码格式,value为视频文件扩展名
  SUPPORT_VIDEO_FORMAT = {"m4v" => ["mp4", "m4v"], "ogv" => ["ogv"], "webmv" => ["webm"], "flv" => ["flv"], "m3u8v" => ["m3u8v"], "m3uv" => ["m3uv"]}

  def self.jplayer_format(extname)
    SUPPORT_VIDEO_FORMAT.invert.each do |key, value|
      temp_value = value
      return temp_value if key.include?(extname)
    end
  end


  def kindergarten_label
    self.kindergarten ? self.kindergarten.name : "没设定幼儿园"
  end

  def squad_label
    self.squad ? self.squad.name : "全园可见"
  end

  def is_top_label
    is_top ? "置顶" : "未置顶"
  end

  private
  def correct_url_address_format
    if !url_address.blank? && !url_address.match(/\.[a-z0-9]+\z/)
      errors[:url_address] << "url地址格式不正确"
    end
  end
end
