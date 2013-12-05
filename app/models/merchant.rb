#encoding:utf-8
#商家
class Merchant < ActiveRecord::Base
  attr_accessible :name, :note,:status

  validates :name,:presence => true, :length => { :maximum => 20 }
  has_one :asset_img, :class_name => "AssetImg", :as => :resource, :dependent => :destroy
  STATUS_DATA = {"0"=>"正常","1"=>"关闭"}

  def status_label
    Merchant::STATUS_DATA[self.status.to_s]
  end

end
