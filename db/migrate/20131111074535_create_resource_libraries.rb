class CreateResourceLibraries < ActiveRecord::Migration
  def change
    create_table :resource_libraries do |t|
      t.string :resource_avatar
      t.integer :user_id
      t.string :file_name
      t.integer :file_size

      t.timestamps
    end
  end
end
