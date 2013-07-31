class CreateNews < ActiveRecord::Migration
  def change
    create_table :news do |t|
      t.string :title
      t.text :content
      t.integer :create_id
      t.integer :approver_id
      t.integer :approve_status, :default => 0
      t.string :note
      t.integer :show_count , :default => 0 #浏览次数
      t.integer :kindergarten_id
       
      t.timestamps
    end
  end
end
