class AddTwoAttributesToComments < ActiveRecord::Migration
  def change
    add_column :comments, :is_show, :boolean, default: true
    add_column :comments, :deleted_at, :timestamp
  end
end
