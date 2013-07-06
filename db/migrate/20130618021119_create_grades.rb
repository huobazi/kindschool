class CreateGrades < ActiveRecord::Migration
  def change
    create_table :grades do |t|
      t.string :name
      t.integer :kindergarten_id
      t.integer :staff_id
      t.text :note
      t.integer :sequence,:default=>0

      t.timestamps
    end
  end
end
