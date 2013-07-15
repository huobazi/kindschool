class CreateOptionOperates < ActiveRecord::Migration
  def self.up
    create_table :option_operates do |t|
      t.column :kindergarten_id,:integer
      t.column :operate_id , :integer
      # 是否显示在主界面上
      # t.column :rename
      t.column :visible,:boolean,:default =>true
    end
  end

  def self.down
    drop_table :option_operates
  end
end
