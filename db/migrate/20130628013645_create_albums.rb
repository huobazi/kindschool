class CreateAlbums < ActiveRecord::Migration
  def change
    create_table :albums do |t|
      t.integer :kindergarten_id
      t.string :title
      t.text :content
      t.integer :creater_id
      t.integer :approve_status
      t.integer :approver_id
      t.integer :tp # 幼儿园活动，班级活动，年级活动，其他活动
      t.integer :is_show, :default => 0 # 0 为不公开, 1为公开
      t.timestamp :send_date
      t.integer :squad_id
      t.string :squad_name
      t.integer :grade_id
      t.integer :album_entry_id

      t.timestamps
    end
  end
end
