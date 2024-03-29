#encoding:utf-8
class CareerStrategy < ActiveRecord::Base
  attr_accessible :add_squad, :from_id, :graduation, :kindergarten_id, :to_id,:squad_name,:to_grade_id
  
  belongs_to :kindergarten
  belongs_to :from, :class_name => "Squad", :foreign_key => "from_id"
  belongs_to :to, :class_name => "Squad", :foreign_key => "to_id"
  belongs_to :to_grade, :class_name => "Grade", :foreign_key => "to_grade_id"

  validates :kindergarten_id, :presence => true
  validates :from_id, :uniqueness => {:scope=>:kindergarten_id},:presence=>true
  validates :to_id,:presence =>{:if=>:is_graduation?}, :uniqueness => {:scope=>:kindergarten_id,:if=>:is_add_squad?}

  def kindergarten_label
    self.kindergarten ? self.kindergarten.name : "没设定幼儿园"
  end

  ADD_SQUAD_DATA = {"true"=>"是","false"=>"否"}
  GRADUATION_DATA = {"true"=>"是","false"=>"否"}

  #是否新加
  def is_add_squad?
    self.add_squad
  end
  #是否毕业班
  def is_graduation?
    !self.graduation
  end

  before_save :load_squad_name

  private
  def load_squad_name
    if self.to_id
      if to_squad = Squad.find_by_id_and_kindergarten_id(self.to_id,self.kindergarten_id)
        self.squad_name = to_squad.name
        self.to_grade_id = to_squad.grade_id
      end
    else
      self.squad_name = ""
    end
  end
end
