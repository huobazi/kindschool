#encoding:utf-8
#评估管理，主表，与幼儿园一对一
class Evaluate < ActiveRecord::Base
  attr_accessible :kindergarten_id, :note
  belongs_to :kindergarten
  has_many :evaluate_entries
  after_save :export_demo
  private
  #创建demo项目
  def export_demo
      evaluate = YAML.load_file("#{Rails.root}/db/basic_data/evaluate.yml")
      evaluate.each do |k,evaluate|
        evaluate_entry = EvaluateEntry.new(evaluate)
      	evaluate_entry.kindergarten=self.kindergarten
      	self.evaluate_entries << evaluate_entry
      end
  end
end