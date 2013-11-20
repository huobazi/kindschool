class CreatePersonalSets < ActiveRecord::Migration
  def change
    create_table :personal_sets do |t|
      t.integer :resource_id
      t.string :resource_type
      t.integer :user_id
      t.timestamps
    end
  end
end
