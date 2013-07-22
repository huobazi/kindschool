class CreateTopics < ActiveRecord::Migration
  def change
    create_table :topics do |t|
      t.integer :kindergarten_id
      t.integer :creater_id
      t.string :title
      t.text :content
      t.integer :topic_category_id
      t.boolean :is_show, :default => true
      t.boolean :is_top
      t.string :status
      t.string :approve_status # 审核状态
      t.integer :approver_id
      t.integer :show_count, :default => 0# 查看次数

      t.timestamps
    end
  end
end
