class UserSquad < ActiveRecord::Base
  attr_accessible :squad_id, :user_id
  belongs_to :user
  belongs_to :squad, :conditions => "squad.tp = 1"' 
end
