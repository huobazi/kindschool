class RemoveAddressInfoFromOrderInfo < ActiveRecord::Migration
  def up
  	remove_column :order_infos, :address_info    
  	remove_column :order_infos, :phone
  	remove_column :order_infos, :address
  	remove_column :order_infos, :delivery_address_id  	    
    add_column :orders, :address_info, :string    
    add_column :orders, :phone, :string
  	add_column :orders, :address, :string
  	add_column :orders, :delivery_address_id, :integer 	    
  	  
  end

  def down
  	add_column :order_infos, :address_info, :string    
    add_column :order_infos, :phone, :string
  	add_column :order_infos, :address, :string
  	add_column :order_infos, :delivery_address_id, :integer 	    
    remove_column :orders, :address_info    
  	remove_column :orders, :phone
  	remove_column :orders, :address
  	remove_column :orders, :delivery_address_id  	    

  end
end
