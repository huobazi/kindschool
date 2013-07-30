class CreateSmsRecords < ActiveRecord::Migration
  def change
    create_table :sms_records do |t|
      t.string :chain_code #扩展码
      t.integer :status, :default =>0 #0正常，1短信已发送，2短信发送失败
      t.integer :message_entry_id
      
      t.integer :sender_id
      t.string :sender_name
      t.string :sender_phone
      t.text :content
      t.integer :receiver_id
      t.string :receiver_name
      t.string :receiver_phone
      t.integer :kindergarten_id
      t.timestamps
    end
  end
end
