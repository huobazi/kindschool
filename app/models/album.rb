#encoding:utf-8
class Album < ActiveRecord::Base
  attr_accessible :album_entry_id,:approve_status, :approver_id, :content, :creater_id, :grade_id, :is_show, :kindergarten_id, :send_date, :squad_id, :squad_name, :title, :tp, :is_top, :accessed_at

  paginates_per 6

  default_scope order("albums.is_top DESC, albums.created_at DESC")

  belongs_to :kindergarten
  belongs_to :squad
  belongs_to :grade
  belongs_to :creater, :class_name => "User", :foreign_key => "creater_id"
  has_many :album_entries , :dependent => :destroy
  has_many :comments , :as => :resource, :dependent => :destroy
  validate_harmonious_of :content

  validates :title, :presence => true, :length => {:minimum=> 3, :maximum=> 20}

  include UnreadComment

  def is_show_label
    is_show ? "是" : "否"
  end

  def show_main_img
    if self.album_entry_id && (record = self.album_entries.find_by_id(self.album_entry_id))
      album_entry = record
    else
      album_entry = self.album_entries.first unless self.album_entries.blank?
    end
    if album_entry
      asset_img = album_entry.asset_img
    end
    asset_img
  end

  def is_top_label
    is_top ? "是" : "否"
  end

  def comments_count_label
    comments.count
  end

  def album_entries_count_label
    album_entries.count
  end
  def grade_label
    self.grade ? self.grade.name : "未设置年级"
  end
  def kindergarten_label
    self.kindergarten ? self.kindergarten.name : "没设定幼儿园"
  end

  def squad_label
    self.squad ? self.squad.name : "全园可见"
  end

  def self.squad_albums(kind)
    select("count(albums.squad_id) as squad_count, sq.name as squad_name").joins("LEFT JOIN squads as sq on (sq.id = albums.squad_id)").where("albums.kindergarten_id = ?", kind.id).group("albums.squad_id")
  end

  def self.creater_albums(kind)
    select("count(albums.creater_id) as creater_count, us.name as creater_name").joins("INNER JOIN users as us on (us.id = albums.creater_id)").where("albums.kindergarten_id = ?", kind.id).group("albums.creater_id")
  end

end
