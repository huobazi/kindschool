#encoding:utf-8
class Report < ActiveRecord::Base
  attr_accessible :content, :informants_id, :process, :resource_id, :resource_type

  belongs_to :informants, :class_name => 'User', :foreign_key => "informants_id"

  validate :resource_type, :resource_id, :informants_id, :presence => true

  PROCESS = {'0' => '未处理', '1' => '已解决', '2' => '正在处理'}

  def process_label
    Report::PROCESS[self.process.to_s]
  end

  def create_report(resource_type, resource_id)
    self.resource_id = resource_id
    self.resource_type = resource_type
    self.save
  end

end
