class CreateNotices < ActiveRecord::Migration
  def change
    create_table :notices do |t|
      t.integer :kindergarten_id
      t.integer :creater_id
      t.string :title
      t.text :content
      t.timestamp :send_date
      t.integer :approve_status
      t.integer :approver_id
      t.integer :status
      t.integer :send_range
      t.integer :send_range_ids

      t.timestamps
    end
  end
end
