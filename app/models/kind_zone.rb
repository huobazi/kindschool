#encoding:utf-8
class KindZone < ActiveRecord::Base
  attr_accessible :code, :lft, :name, :parent_id, :remark, :rgt

  acts_as_nested_set

  before_save :save_kind_zone_level

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
    child_list = self.class.where(:parent_id => self.id)
  end

  private
    def save_kind_zone_level
      self.level = 0
      _parent = self.parent
      while !_parent.nil?
        self.level +=1
        _parent=_parent.parent
      end
    end
end
