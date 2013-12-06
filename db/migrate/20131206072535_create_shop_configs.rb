class CreateShopConfigs < ActiveRecord::Migration
  def change
    create_table :shop_configs do |t|
      t.string :number
      t.string :note
      t.integer :status,

      t.timestamps
    end
  end
end
