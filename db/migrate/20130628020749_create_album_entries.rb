class CreateAlbumEntries < ActiveRecord::Migration
  def change
    create_table :album_entries do |t|
      t.integer :album_id
      t.integer :asset_img_id
      t.string :title

      t.timestamps
    end
  end
end
