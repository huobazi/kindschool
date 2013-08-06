class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.integer :kindergarten_id
      t.integer :sender_id
      t.string :sender_name
      t.string :title
      t.text :content
      t.integer :tp ,:default => 0# 分两种,只发站内(0),站内加短信(1),系统消息(2)
      t.boolean :status, :default => 0 # 0是草稿,1是已发送
      t.integer :approve_status, :default => 0
      t.integer :approver_id
      t.integer :parent_id
      t.integer :entry_id #所属子回复
      t.string :chain_code #扩展号
      t.timestamp :send_date
      t.timestamp :deleted_at
      t.timestamps
    end
  end
end
