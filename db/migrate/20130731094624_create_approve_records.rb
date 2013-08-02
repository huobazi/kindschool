class CreateApproveRecords < ActiveRecord::Migration
  def change
    create_table :approve_records do |t|
      t.string :resource_type
      t.integer :resource_id
      t.integer :status, :default =>1

      t.timestamps
    end
  end
end
