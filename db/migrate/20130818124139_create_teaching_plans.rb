class CreateTeachingPlans < ActiveRecord::Migration
  def change
    create_table :teaching_plans do |t|
      t.integer :kindergarten_id
      t.integer :creater_id
      t.string :title
      t.text :content
      t.integer :squad_id

      t.timestamps
    end
  end
end
