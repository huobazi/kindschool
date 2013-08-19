class AddAllSmsTomessages < ActiveRecord::Migration
  def change
    add_column :messages, :allsms, :boolean, :default => false  #是否所有都发短信
    add_column :sms_records, :sms_count, :integer, :default => 1  #短信数量，70个字为一条短信
  end
end
