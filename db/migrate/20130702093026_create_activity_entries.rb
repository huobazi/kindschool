class CreateActivityEntries < ActiveRecord::Migration
  def change
    create_table :activity_entries do |t|
      t.integer :activity_id
      t.text :note
      t.integer :tp, :default => 1 # 0 为活动主信息, 1 为交互信息
      t.integer :creater_id

      t.timestamps
    end
  end
end
