class CreateActivityImgs < ActiveRecord::Migration
  def change
    create_table :activity_imgs do |t|
      t.string :filename
      t.string :resource_type, :limit => 50
      t.integer :resource_id
      t.string :content_type
      t.integer :size
      t.integer :width
      t.integer :height
      t.integer :parent_id
      t.string :thumbnail
      t.string :alt
      t.timestamp :created_at

      t.timestamps
    end
  end
end
