class CreateCreditLogs < ActiveRecord::Migration
  def change
    create_table :credit_logs do |t|
      t.integer :kindergarten_id
      t.integer :resource_id
      t.string :resource_type
      t.integer :tp  ,:default=>0
      t.string :note
      t.float :credit,:default=>0
      t.integer :business_id
      t.string :business_type

      t.timestamps
    end
  end
end
