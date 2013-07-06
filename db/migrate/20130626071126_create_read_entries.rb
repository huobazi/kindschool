class CreateReadEntries < ActiveRecord::Migration
  def change
    create_table :read_entries do |t|
      t.integer :topic_id
      t.integer :user_id

      t.timestamps
    end
  end
end
