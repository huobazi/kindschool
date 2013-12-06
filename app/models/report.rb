class Report < ActiveRecord::Base
  attr_accessible :content, :informants, :process, :resource_id, :resource_type
end
