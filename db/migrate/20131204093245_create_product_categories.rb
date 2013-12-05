#encoding:utf-8
#商品分类
class CreateProductCategories < ActiveRecord::Migration
  def change
    create_table :product_categories do |t|
      t.string :name
      t.string :parent_id
      t.string :note

      t.timestamps
    end
  end
end
