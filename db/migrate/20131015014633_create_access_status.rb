class CreateAccessStatus < ActiveRecord::Migration
  def change
    create_table :access_status do |t|
      t.integer :user_id
      t.string :module_name
      t.timestamp :accessed_at

      t.timestamps
    end

    add_index :access_status, :accessed_at
  end
end
