class AddStartDataToNews < ActiveRecord::Migration
  def change
    add_column :news, :start_data, :timestamp
  end
end
