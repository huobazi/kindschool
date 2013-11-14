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
        evaluate_entry = EvaluateEntry.new()
      	evaluate_entry.a_indicator = evaluate["a_indicator"]
        evaluate_entry.b_indicator = evaluate["b_indicator"]
        evaluate_entry.name = evaluate["name"]
        evaluate_entry.article_case = evaluate["article_case"] 
        evaluate_entry.sequence = evaluate["sequence"].to_i
        evaluate_entry.note = evaluate["note"]
        (evaluate["evaluate_vtocs"] || []).each do |k,evaluate_vtoc|
           evaluate_vtocs=EvaluateVtoc.new()
           evaluate_vtocs.name = evaluate_vtoc
           evaluate_vtocs.kindergarten=self.kindergarten
           evaluate_entry.evaluate_vtocs<<evaluate_vtocs
        end
        evaluate_entry.kindergarten=self.kindergarten
        self.evaluate_entries << evaluate_entry
      end
  end
end
