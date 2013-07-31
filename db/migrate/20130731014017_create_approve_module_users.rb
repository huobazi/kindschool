class CreateApproveModuleUsers < ActiveRecord::Migration
  def change
    create_table :approve_module_users do |t|
      t.integer :user_id
      t.integer :approve_module_id

      t.timestamps
    end
  end
end
