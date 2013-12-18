class AddImgIdToProduct < ActiveRecord::Migration
  def change
    add_column :products, :img_id, :integer
  end
end
