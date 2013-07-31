class ApproveModule < ActiveRecord::Base
  attr_accessible :kindergarten_id,:name, :number, :status
  has_many  :approve_module_users
  belongs_to :kindergarten

end
