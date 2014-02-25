#encoding:utf-8
#tp：0，普通老师，1为班主任
class Teacher < ActiveRecord::Base
  attr_accessible :squad_id, :staff_id, :tp

  belongs_to :staff
  belongs_to :squad

  validates :staff, :squad, :presence => true
  validates :staff_id, :uniqueness => {:scope => :squad_id}

  TP_DATA={"0" => "普通老师", "1" => "班主任"}

end
