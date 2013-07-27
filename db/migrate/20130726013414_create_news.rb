class CreateNews < ActiveRecord::Migration
  def change
    create_table :news do |t|
      t.string :title
      t.text :content
      t.integer :create_id
      t.integer :approver_id
      t.integer :approve_status
      t.string :note
      t.integer :kindergarten_id

      t.timestamps
    end
  end
end
