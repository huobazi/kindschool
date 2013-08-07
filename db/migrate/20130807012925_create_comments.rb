class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
      t.integer :kindergarten_id
      t.boolean :visible,:default=>false  #是否显示
      t.integer :parent_id  #回复哪个的评论id，要求resource必须是一样的
      t.integer :user_id
      t.integer :resource_id 
      t.string :resource_type
      t.text :comment
      t.timestamps
    end
  end

  def self.down
    drop_table :comments
  end
end
