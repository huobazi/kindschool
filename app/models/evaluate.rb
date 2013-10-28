#encoding:utf-8
#评估管理，主表，与幼儿园一对一
class Evaluate < ActiveRecord::Base
  attr_accessible :kindergarten_id, :note
  belongs_to :kindergarten

end
