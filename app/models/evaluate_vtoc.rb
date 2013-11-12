#encoding:utf-8
#卷目录
class EvaluateVtoc < ActiveRecord::Base
  #:self_note #自评说明
  #:article_case #案条
  attr_accessible :kindergarten_id, :name,:evaluate_entry_id,:sequence
  belongs_to :kindergarten
  belongs_to :evaluate_entry
  has_many :evaluate_assets,:class_name=>"EvaluateAsset", :as => :resource, :dependent => :destroy
  validates :name, :presence => true
end
