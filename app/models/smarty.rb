#encoding:utf-8
#常用功能
class Smarty < ActiveRecord::Base
  attr_accessible :option_operate_id, :role_id, :rename
  belongs_to :option_operate
  belongs_to :role
end
