class CreateCookBooks < ActiveRecord::Migration
  def change
    create_table :cook_books do |t|
      t.integer :kindergarten_id
      t.timestamp :start_at
      t.timestamp :end_at
      t.integer :range_tp, :default => 0 # 0为一周菜谱, 1为一天菜谱
      t.text :content
      t.integer :creater_id

      t.timestamps
    end
  end
end
