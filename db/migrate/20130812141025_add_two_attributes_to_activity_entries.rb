class AddTwoAttributesToActivityEntries < ActiveRecord::Migration
  def change
    add_column :activity_entries, :is_show, :boolean, default: true
    add_column :activity_entries, :deleted_at, :timestamp
  end
end
