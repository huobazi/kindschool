class CreateApproveEntries < ActiveRecord::Migration
  def change
    create_table :approve_entries do |t|
      t.integer :approve_record_id
      t.integer :user_id
      t.text :note
      t.integer :status

      t.timestamps
    end
  end
end
