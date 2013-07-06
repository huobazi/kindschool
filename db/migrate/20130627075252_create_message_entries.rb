class CreateMessageEntries < ActiveRecord::Migration
  def change
    create_table :message_entries do |t|
      t.integer :message_id
      t.integer :receiver_id
      t.string :receiver_name
      t.integer :status
      t.integer :sms
      t.string :phone
      t.text :content

      t.timestamps
    end
  end
end
