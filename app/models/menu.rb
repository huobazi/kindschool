#encoding:utf-8
class Menu < ActiveRecord::Base
  attr_accessible :operate_id,:id, :height_level,:kindergarten_id,:parent_id,:number,:name,:url,:title,:visible, :sequence

  acts_as_tree

  belongs_to :kindergarten
  belongs_to :parented, :class_name=>'Menu', :foreign_key=>'parent_id'
  has_many :children, :class_name=>'Menu', :foreign_key=>'parent_id'

  validates  :number,:name,:url , :presence => true#:kindergarten, #必须输入/不为空
  validates_uniqueness_of  :number ,:scope=>:kindergarten_id  #同一幼儿园不允许重复

  def visible_label
    visible ? "是" : "否"
  end

end
