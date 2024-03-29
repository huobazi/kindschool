#encoding:utf-8
#评估管理方案39条细则
class EvaluateEntry < ActiveRecord::Base
  #:self_note #自评说明
  #:article_case #案条
  attr_accessible :b_indicator,:a_indicator,:kindergarten_id, :note,:evaluate_id,:name,:article_case,:sequence,:note,:self_note
  belongs_to :kindergarten
  belongs_to :evaluate#, :dependent => :destroy
  has_many :evaluate_vtocs, :dependent => :destroy
  validates :name, :presence => true
end
