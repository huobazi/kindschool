class CreateSeedlingRecords < ActiveRecord::Migration
  def change
    create_table :seedling_records do |t|
      t.integer :kindergarten_id
      t.string :name
      t.integer :student_info_id
      t.integer :creater_id # 创建人,老师能建
      t.text :note
      t.timestamp :shot_at # 注射时间
      t.timestamp :expire_at # 过期时间

      t.timestamps
    end
  end
end
