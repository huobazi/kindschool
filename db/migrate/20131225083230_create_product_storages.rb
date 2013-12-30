class CreateProductStorages < ActiveRecord::Migration
  def change
    create_table :product_storages do |t|
      t.integer :product_id
      t.integer :count
      t.integer :tp
      t.text :note

      t.timestamps
    end
  end
end
