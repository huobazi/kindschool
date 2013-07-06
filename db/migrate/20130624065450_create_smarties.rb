#常用功能
class CreateSmarties < ActiveRecord::Migration
  def self.up
    create_table :smarties do |t|
      t.integer :option_operate_id  #功能操作
      t.string :role_id  #所属角色
      t.string :rename  #别名
    end
  end

  def self.down
    drop_table :smarties
  end
end
