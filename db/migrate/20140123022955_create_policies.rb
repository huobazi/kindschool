class CreatePolicies < ActiveRecord::Migration
  def change
    create_table :policies do |t|
      t.string :title
      t.text :content
      t.integer :kindergarten_id

      t.timestamps
    end
  end
end
