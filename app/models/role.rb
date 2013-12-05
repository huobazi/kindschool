#encoding:utf-8
#角色
class Role < ActiveRecord::Base
  attr_accessible :kindergarten_id, :name, :number, :admin, :note

  belongs_to :kindergarten
  has_and_belongs_to_many :option_operates
  has_many :operates,:through=>:option_operates
  has_many :users
  has_many :smarties
  validates :name, :kindergarten, :presence => true  #必须输入/不为空
  validates :name, :uniqueness => { :scope => :kindergarten_id }
  validates :number, :presence => true

  def kindergarten_label
    self.kindergarten ? self.kindergarten.name : "没设定幼儿园"
  end

  def admin_label
    admin ? "是" : "否"
  end
end
