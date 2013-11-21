#encoding:utf-8
class Topic < ActiveRecord::Base
  attr_accessible :approve_status, :approver_id, :content, :creater_id, :is_show, :is_top, :kindergarten_id, :show_count, :status, :title, :tp, :topic_category_id, :squad_id
  attr_accessible :appurtenance_upload_limit
  validates :kindergarten_id, :creater_id, :topic_category_id, :title, :content, :presence => true
  validates :title, :length => { :minimum => 3, :maximum => 100 }
  validates :content, :length => { :minimum => 3 }

  belongs_to :kindergarten
  belongs_to :topic_category
  belongs_to :creater, :class_name => "User", :foreign_key => "creater_id"
  belongs_to :squad
   
  has_many :appurtenances, :class_name => "Appurtenance", :as => :resource, :dependent => :destroy

  has_many :topic_entries
  has_many :goodbacks, :class_name => "TopicEntry", :foreign_key => "topic_id",:order=>"id",:conditions=>"goodback=1"

  has_one :approve_record,:class_name=>"ApproveRecord", :as => :resource, :dependent => :destroy

  include ResourceApproveStatusStart
  before_save :news_approve_status_start

  before_destroy :ensure_not_topic_entries

  def unread_comment_count
    if accessed_at
      topic_entries.where("created_at > ?", accessed_at).count
    else
      topic_entries.count
    end
  end

  def kindergarten_label
    self.kindergarten ? self.kindergarten.name : "没设定幼儿园"
  end

  def change_arry_approve_record
     [:content,:title] 
  end
 

  def topic_category_label
    self.topic_category ? self.topic_category.name : "论坛分类信息丢失"
  end

  def last_page
    page = (self.topic_entries.count.to_f / 10).ceil
    page > 1 ? page : nil
  end

  def squad_label
    self.squad ? self.squad.name : "没有班级信息"
  end

  def ensure_not_topic_entries
    unless self.topic_entries.blank?
      self.topic_entries.each do |topic_entry|
        topic_entry.is_show = false
        topic_entry.save
      end
    end
  end

end
