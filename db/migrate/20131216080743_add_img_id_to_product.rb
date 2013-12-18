class AddImgIdToProduct < ActiveRecord::Migration
  def change
    add_column :products, :img_id, :integer
    add_column :products, :merchant_id, :integer
    add_column :products, :note, :text
    change_column :products, :description, :string
  end
end
