class CreateMessageEntries < ActiveRecord::Migration
  def change
    create_table :message_entries do |t|
      t.integer :message_id
      t.integer :receiver_id
      t.string :receiver_name
      t.integer :status, :default =>0 #0正常，1短信已发送，2短信发送失败
      t.boolean :read_status, :default => false #阅读状态
      t.integer :sms, :default =>0 #短信服务 0为非短信服务，1为短信服务（需要发短信）
      t.string :phone
      t.text :content
      t.timestamp :deleted_at
      t.timestamps
    end
  end
end
