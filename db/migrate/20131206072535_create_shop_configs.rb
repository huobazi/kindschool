#encoding:utf-8
class CreateShopConfigs < ActiveRecord::Migration
  def migrate(direction)
    super
    # Create a default ShopConfig
    ShopConfig.create!(:number=>"logo",:name=>"微一积分商城",:note=>"微一积分商城，关注您孩子的兴趣培养") if direction == :up
  end
  def change
    create_table :shop_configs do |t|
      t.string :number
      t.string :name
      t.text :note
      t.integer :status, :default => 0
      t.timestamps
    end
  end
end
