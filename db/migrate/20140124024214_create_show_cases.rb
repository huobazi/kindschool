class CreateShowCases < ActiveRecord::Migration
  def change
    create_table :show_cases do |t|
      t.integer :kindergarten_id
      t.integer :creater_id
      t.integer :user_id   #所属学生
      t.string :title
      t.string :note
      t.timestamps
    end
  end
end
