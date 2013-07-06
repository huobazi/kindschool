#encoding:utf-8
#功能
class Operate < ActiveRecord::Base
  attr_accessible  :id,:name, :parent_id, :controller, :action,:params,:protocol,:note,:level,:sequence,:operates_count,:authable,:visible

  has_many :option_operates
  has_many :kindergartens, :through => :option_operates
  acts_as_tree :order=>'sequence',:counter_cache=>true
  validates    :name  , :presence => true   #必须输入/不为空
  def self.main_menus
    self.find_all_by_parent_id(1,
      :select=>"id,name,controller,action,params",
      :order=>'sequence')
  end
end
