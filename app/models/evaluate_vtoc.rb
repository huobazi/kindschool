#encoding:utf-8
#卷目录
class EvaluateVtoc < ActiveRecord::Base
  #:self_note #自评说明
  #:article_case #案条
  attr_accessible :kindergarten_id, :name,:evaluate_enty_id,:sequence
  belongs_to :kindergarten
  belongs_to :evaluate_enty
  validates :name, :presence => true
end
