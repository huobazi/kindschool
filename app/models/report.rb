#encoding:utf-8
class Report < ActiveRecord::Base
  attr_accessible :content, :informants_id, :process, :resource_id, :resource_type

  belongs_to :informants, :class_name => 'User', :foreign_key => "informants_id"
  belongs_to :kindergarten

  validates :resource_type, :resource_id, :informants_id, :presence => true
  validates :informants_id, :uniqueness => {:scope => [:resource_id, :resource_type]}

  PROCESS = {'0' => '未处理', '1' => '已解决', '2' => '正在处理'}

  def process_label
    Report::PROCESS[self.process.to_s]
  end

  class << self
    def find_report_for_resource(user, resource_type, resource_id)
      where(:informants_id => user, :resource_type => resource_type, :resource_id => resource_id)
    end
  end

  def create_report(resource_type, resource_id, kind)
    self.resource_id = resource_id
    self.resource_type = resource_type
    self.kindergarten = kind
    self.save
  end

end
