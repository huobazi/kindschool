#encoding:utf-8
#商品
class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :name
      t.integer :product_category_id
      t.float :credit,:default=>0
      t.float :price,:default=>0
      t.float :market_price,:default=>0
      t.integer :approve_id
      t.integer :user_id
      t.string :keywords
      t.text :description
      t.integer :view_asset_id
      t.string :meaning
      t.integer :shop_id
      t.integer :status,:default=>0

      t.timestamps
    end
  end
end
