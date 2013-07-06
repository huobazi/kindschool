class Teacher < ActiveRecord::Base
  attr_accessible :squad_id, :staff_id, :tp

  belongs_to :staff
  belongs_to :squad

  validates :staff, :squad, :presence => true

  validates :staff_id, :uniqueness => {:scope => :squad_id}
end
