class AddParentIdToProductCategory < ActiveRecord::Migration
  def change
  	 change_column :product_categories, :parent_id, :integer
  end
end
