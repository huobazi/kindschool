#encoding:utf-8
#功能
class OptionOperate < ActiveRecord::Base
  attr_accessible :rename,:kindergarten_id, :operate_id,:visible

  has_and_belongs_to_many :roles
  has_many :smarties
  belongs_to :kindergarten
  belongs_to :operate

  validates    :kindergarten ,:operate , :presence => true   #必须输入/不为空
  validates_uniqueness_of  :operate_id ,:scope=>:kindergarten_id  #同一幼儿园不允许重复


  def kindergarten_label
    self.kindergarten ? self.kindergarten.name : "没设定幼儿园"
  end

end
