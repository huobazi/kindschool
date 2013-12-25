class AddLftToProductCategory < ActiveRecord::Migration
  def change
  	add_column :product_categories, :lft, :integer
    add_column :product_categories, :rgt, :integer
    add_column :product_categories, :level, :integer
  end
end
