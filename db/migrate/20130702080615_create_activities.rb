class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.integer :kindergarten_id
      t.string :title
      t.text :content
      t.string :logo
      t.integer :creater_id
      t.integer :approve_status, :default => 0
      t.integer :approver_id
      t.timestamp :start_at
      t.timestamp :end_at
      t.text :note
      t.integer :send_range
      t.integer :send_range_ids
      t.integer :tp, :default => 0 # 0为活动,1为兴趣讨论
      t.integer :squad_id

      t.timestamps
    end
  end
end
