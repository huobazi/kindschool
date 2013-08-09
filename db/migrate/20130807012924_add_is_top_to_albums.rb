class AddIsTopToAlbums < ActiveRecord::Migration
  def change
    add_column :albums, :is_top, :boolean, :default => false
  end
end
