class CreateTeachers < ActiveRecord::Migration
  def change
    create_table :teachers do |t|
      t.integer :staff_id
      t.integer :squad_id
      t.integer :tp, :default => 0 #0，普通老师，1为班主任

      t.timestamps
    end
  end
end
