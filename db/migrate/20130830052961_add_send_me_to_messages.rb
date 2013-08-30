#encoding:utf-8
class AddSendMeToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :send_me, :boolean, :default => true  #短信发给自己
  end
end
