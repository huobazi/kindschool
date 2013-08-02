#encoding:utf-8
#审核记录
class ApproveRecord < ActiveRecord::Base
  attr_accessible :resource_id, :resource_type, :status
  belongs_to :resource, :polymorphic => true #指定审核的类型/对象
  has_many :approve_entries
  STATUS = { 0=>"通过",1=> "待审核",2=> "不通过"}
  before_save :change_new_status
  private
  def change_new_status
    if  self.status == 2
      unless self.resource.approve_status==2
      	self.resource.approve_status=2
        self.resource.save
      end
    elsif self.status==0
      unless self.resource.approve_status==0
    	 self.resource.approve_status=0
       self.resource.save
      end
    end 
  end
end
