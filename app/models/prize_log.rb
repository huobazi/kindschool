#encoding:utf-8
#奖品表日志
class PrizeLog < ActiveRecord::Base
  attr_accessible :kindergarten_id, :resource_id, :resource_id, :stage_credit, :status, :user_id
end
