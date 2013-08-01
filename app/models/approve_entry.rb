class ApproveEntry < ActiveRecord::Base
  attr_accessible :approve_record_id, :note, :status, :user_id
end
