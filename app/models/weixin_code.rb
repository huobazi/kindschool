#encoding:utf-8
class WeixinCode < ActiveRecord::Base
  attr_accessible :kindergarten_id, :user_id, :weixin_code, :weixin_tp

  belongs_to :kindergarten
  belongs_to :user

  TP_DATA = {"0" => "订阅号", "1" => "服务号"}

  def tp_label
    WeixinCode::TP_DATA[weixin_tp.to_s] if weixin_tp
  end
end
