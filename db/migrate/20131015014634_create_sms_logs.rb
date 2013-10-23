class CreateSmsLogs < ActiveRecord::Migration
  def change
    create_table :sms_logs do |t|
      t.integer :kindergarten_id
      t.integer :user_id
      t.integer :admin_user_id
      t.integer :count, :default => 0
      t.integer :tp, :default => 0
      t.integer :message_id
      t.string :note
      t.timestamps
    end
    add_index :sms_logs,:kindergarten_id
    add_index :sms_logs,:tp
    add_index :sms_logs, :created_at
    
    add_column :kindergartens, :balance_count, :integer, :default => 0  #剩余短信数量
  end
end
