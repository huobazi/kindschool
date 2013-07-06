class CreateStudentResources < ActiveRecord::Migration
  def change
    create_table :student_resources do |t|
      t.integer :student_info_id

      t.timestamps
    end
  end
end
