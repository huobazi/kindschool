class CreateReadUsers < ActiveRecord::Migration
  def change
    create_table :read_users do |t|
      t.integer :kindergarten_id
      t.integer :user_id
      t.string :user_name
      t.string :resource_type, :limit => 50 #类型
      t.integer :resource_id #ID
      t.timestamps
    end
  end
end
