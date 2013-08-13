class CreateRetPasswordRecords < ActiveRecord::Migration
  def change
    create_table :ret_password_records do |t|
      t.integer :user_id

      t.timestamps
    end
  end
end
