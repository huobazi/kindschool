#encoding:utf-8
class KindZone < ActiveRecord::Base
  attr_accessible :code, :lft, :name, :parent_id, :remark, :rgt

  acts_as_nested_set

  has_many :kindergartens
  has_many :policies

  before_save :save_kind_zone_level

  validates :name, :presence => true

  # 返回二级选择菜单
  def self.data
    roots.select("id, name").map do |k|
      b = {}
      b['id'] = k.id
      b['name'] = k.name
      b['citys'] = k.children.select("id,name").map do |v|
        s = {}
        s['id'] = v.id
        s['name'] = v.name
        s
      end
      b
    end.to_json
  end

  def self.city_select(obj)
    js = <<EOF
      <div class="control-group">
        <label class="control-label" for="province">城市</label>
        <div class="controls">
          <select id="province">
            <option value="载入中"></option>
          </select>
        </div>
      </div>
      <div class="control-group">
        <label class="control-label" for="city">区或县</label>
        <div class="controls">
          <select id="city" name="#{obj.class.to_s.underscore}[kind_zone_id]">
            <option value="载入中"></option>
          </select>
        </div>
      </div>
      <script type="text/javascript">
      $(document).ready(function() {
        var data = #{KindZone.data.to_s.html_safe};
        $('#province, #city').citylist({data:data, id:'id', children:'citys',name:'name',metaTag:'name', idVal: true, #{obj.kind_zone.try(:select_default)}});
      })
      </script>
EOF
  end


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
    self.class.where(:parent_id => self.id)
  end

  def zone_name
    _parent = self
    name = []
    while _parent
      name << _parent.name
      _parent = _parent.parent
    end
    name.reverse.join("-")
  end

  def select_default
    "selected: #{self_and_ancestors.map(&:id)}"
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
