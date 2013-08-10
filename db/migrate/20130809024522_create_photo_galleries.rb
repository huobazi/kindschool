class CreatePhotoGalleries < ActiveRecord::Migration
  def change
    create_table :photo_galleries do |t|
       t.column :filename, :string
       t.column :content_type, :string
       t.column :size, :integer
       t.column :width, :integer
       t.column :height, :integer
       t.column :parent_id, :integer
       t.column :thumbnail, :string
       t.column :created_at, :datetime
       t.column :alt, :string
       t.string :url
      t.timestamps
    end
  end
end
