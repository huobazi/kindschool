class CreateMenus < ActiveRecord::Migration
  def self.up
    create_table :menus do |t|
      t.column :kindergarten_id,:integer
      t.integer :parent_id  #上级id
      t.string :number  #编号
      t.string :name  #名称
      t.string :url  #url地址
      t.string :title  #tip
      t.boolean :visible ,:default=>true #是否显示
      t.string :height_level,:defaule=>"a" #菜单的访问位置类型,默认为a类型
      t.integer :operate_id
      t.integer :sequence
    end
  end

  def self.down
    drop_table :menus
  end
end
