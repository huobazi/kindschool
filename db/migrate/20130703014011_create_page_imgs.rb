class CreatePageImgs < ActiveRecord::Migration
  def change
    create_table :page_imgs do |t|
      t.integer :kindergarten_id
      t.integer :content_entry_id
      t.string :filename
      t.string :content_type
      t.string :resource_type, :limit => 50
      t.integer :resource_id
      t.integer :size
      t.integer :width
      t.integer :height
      t.integer :parent_id
      t.string :thumbnail
      t.string :alt
      t.timestamp :created_at

    end
  end
end
