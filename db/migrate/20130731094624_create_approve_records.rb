class CreateApproveRecords < ActiveRecord::Migration
  def change
    create_table :approve_records do |t|
      t.string :resource_type
      t.integer :resource_id
      t.boolean :status

      t.timestamps
    end
  end
end
