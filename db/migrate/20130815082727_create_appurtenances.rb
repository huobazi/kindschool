class CreateAppurtenances < ActiveRecord::Migration
  def change
    create_table :appurtenances do |t|
      t.integer :resource_id
      t.string  :resource_type
      t.string  :avatar
      t.integer :user_id
      t.integer :kindergarten_id
      t.string  :file_name
      t.integer :file_size
      t.timestamps
    end
  end
end
