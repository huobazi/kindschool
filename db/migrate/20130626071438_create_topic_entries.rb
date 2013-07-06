class CreateTopicEntries < ActiveRecord::Migration
  def change
    create_table :topic_entries do |t|
      t.integer :topic_id
      t.text :content
      t.integer :creater_id
      t.string :status

      t.timestamps
    end
  end
end
