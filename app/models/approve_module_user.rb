class ApproveModuleUser < ActiveRecord::Base
  attr_accessible :approve_module_id, :user_id
  belongs_to :approve_module
  belongs_to :user
end
