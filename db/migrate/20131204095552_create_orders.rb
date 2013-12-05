#encoding:utf-8
#订单
class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.string :number
      t.integer :status,:default=>0
      t.integer :user_id
      t.float :amount,:default=>0
      t.float :credit,:default=>0
      t.string :postage
      t.string :note
      t.timestamp :shipment_at
      t.string :express_code
      t.integer :kindergarten_id

      t.timestamps
    end
  end
end
