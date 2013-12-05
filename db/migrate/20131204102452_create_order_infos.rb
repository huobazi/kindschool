class CreateOrderInfos < ActiveRecord::Migration
  def change
    create_table :order_infos do |t|
      t.integer :order_id
      t.integer :product_id
      t.integer :kindergarten_id
      t.float :amount,:default=>0
      t.integer :count,:default=>0
      t.float :credit,:default=>0
      t.string :comment
      t.integer :quality,:default=>0
      t.string :address_info
      t.string :phone
      t.string :address
      t.integer :delivery_address_id

      t.timestamps
    end
  end
end
