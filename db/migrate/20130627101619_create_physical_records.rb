class CreatePhysicalRecords < ActiveRecord::Migration
  def change
    create_table :physical_records do |t|
      t.integer :kindergarten_id
      t.integer :creater_id
      t.integer :student_info_id
      t.timestamp :send_date # 体检时间
      t.text :content # 体检记录

      t.timestamps
    end
  end
end
