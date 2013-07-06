class CreateGrowthRecords < ActiveRecord::Migration
  def change
    create_table :growth_records do |t|
      t.integer :kindergarten_id
      t.boolean :tp, :default => 0 # 0为宝宝在园, 1为宝宝在家
      t.timestamp :start_at
      t.timestamp :end_at
      t.text :content # 在园表现
      t.integer :creater_id
      t.integer :student_info_id
      t.string :squad_name

      t.timestamps
    end
  end
end
