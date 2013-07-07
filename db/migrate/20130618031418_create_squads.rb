class CreateSquads < ActiveRecord::Migration
  def change
    create_table :squads do |t|
      t.string :name
      t.string :historyreview #入院历届年份
      t.integer :kindergarten_id
      t.integer :grade_id
      t.boolean :graduate,:default=>false #是否毕业班级
      t.text :note
      t.integer :sequence,:default=>0
      t.timestamps
    end
  end
end
