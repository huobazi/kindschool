class CreateDeliveryAddresses < ActiveRecord::Migration
  def change
    create_table :delivery_addresses do |t|
      t.integer :kindergarten_id
      t.integer :user_id
      t.string :address_info
      t.string :phone
      t.string :address

      t.timestamps
    end
  end
end
