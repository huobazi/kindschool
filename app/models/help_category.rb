#encoding:utf-8
#帮助的视频分类
class HelpCategory < ActiveRecord::Base
  acts_as_nested_set
  belongs_to :help_movie
  before_save :save_help_category_level
  attr_accessible :help_movie_id,:code,:name,:tp_id, :parent_id, :remark
  TPID = {0=>"学生",1=>"老师",2=>"管理员"}
  def child_levels()
    child_list = self.class.where(:code.gt => self.code, level: self.level+1) # 下级的code及level均大于上级
    # 查找下一个紧挨着的同级，按code顺序排序
    next_same_level_category = self.class.where(:code.gt => self.code, :level => self.level).first
    if next_same_level_category
      # 下级的code 应该 小于同级的code
      child_list = child_list.where(:code.lt => next_same_level_category.code)
    end
    child_list
  end

  def children
     child_list = self.class.where(:parent_id=>self.id)#,:level=>self.level+1)
   end
  private
  def save_help_category_level
     self.level = 0
     _parent = self.parent
     while !_parent.nil?
     	self.level +=1
     	_parent=_parent.parent
     end
  end
end
