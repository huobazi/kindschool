class CreateAssetImgs < ActiveRecord::Migration
  def self.up
    create_table :asset_imgs do |t|
       t.column :filename, :string
       t.column :content_type, :string
       t.string :resource_type, :limit => 50 #类型
       t.integer :resource_id #ID
       t.column :size, :integer
       t.column :width, :integer
       t.column :height, :integer
       t.column :parent_id, :integer
       t.column :thumbnail, :string
       t.column :created_at, :datetime
       t.column :alt, :string
    end
  end

  def self.down
    drop_table :asset_imgs
  end
end
