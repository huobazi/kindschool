class RetPasswordRecord < ActiveRecord::Base
  attr_accessible :user_id
  default_scope order("created_at desc")
  belongs_to :user
end
