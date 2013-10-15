class AccessStatu < ActiveRecord::Base
  attr_accessible :accessed_at, :module_name, :user_id
end
