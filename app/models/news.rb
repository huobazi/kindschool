#encoding:utf-8
#新闻的发布
class News < ActiveRecord::Base
  attr_accessible :approve_status, :approver_id, :content, :create_id, :kindergarten_id, :note, :title
  belongs_to :kindergarten
  belongs_to :creater, :class_name => "User",:foreign_key=>:create_id
  has_one :approve_record,:class_name=>"ApproveRecord", :as => :resource, :dependent => :destroy
  default_scope order("created_at desc") 
  validates :title, :length => { :minimum => 3 }
  validates :content, :length => { :minimum => 3 }
  STATUS = { 0=>"审核通过",1=> "待审核", 2=>"审核不通过"}
  before_save :news_approve_status_start
  protected
  def news_approve_status_start
    if kind =  self.kindergarten
      if approve_module=kind.approve_modules.find_by_number("news")
         if approve_module.status
           if self.approve_status_was == self.approve_status
            self.approve_status = 1
            if  self.approve_record.blank?
            	approve_record = ApproveRecord.new()
            	 self.approve_record = approve_record
               approve_entry=ApproveEntry.new(:note=>"创建了一条新闻")
               self.approve_record.approve_entries << approve_entry
            else
               self.approve_record.status = 1
               approve_entry=ApproveEntry.new(:note=>"更新了该条新闻")
               self.approve_record.approve_entries << approve_entry
            end
           end
         end
      end
    end    
  end
end
