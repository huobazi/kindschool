class ApproveRecords < ActiveRecord::Base
  attr_accessible :resource_id, :resource_type, :status
  belongs_to :resource, :polymorphic => true #指定审核的类型/对象
end
