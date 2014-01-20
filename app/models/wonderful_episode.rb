#encoding:utf-8
# 精彩视频
# title: 标题
# url_address: url地址
# is_top :是否置顶
class WonderfulEpisode < ActiveRecord::Base
  attr_accessible :is_top, :kindergarten_id, :squad_id, :title, :url_address, :user_id

  belongs_to :creater, :class_name => "User", :foreign_key => "user_id"

  validates :kindergarten_id, :url_address, :title, :presence => true

  belongs_to :kindergarten

  belongs_to :squad

  def kindergarten_label
    self.kindergarten ? self.kindergarten.name : "没设定幼儿园"
  end

  def squad_label
    self.squad ? self.squad.name : "全园可见"
  end

  def is_top_label
    is_top ? "置顶" : "未置顶"
  end
end
