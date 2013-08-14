class CreateNotices < ActiveRecord::Migration
  def change
    create_table :notices do |t|
      t.integer :kindergarten_id
      t.integer :creater_id
      t.string :title
      t.text :content
      t.timestamp :send_date
      t.integer :approve_status, :default => 0
      t.integer :approver_id
      t.integer :status
      t.integer :send_range, :default => 0 # "0"=>"全园通知","1"=>"全教职工通知","2"=>"全学生通知"
      t.integer :send_range_ids
      t.timestamps
    end
  end
end
