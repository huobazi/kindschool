class CreateApproveModules < ActiveRecord::Migration
  def change
    create_table :approve_modules do |t|
      t.integer :kindergarten_id
      t.string :number
      t.string :name
      t.boolean :status,:default=>0 #状态是否开启

      t.timestamps
    end
  end
end
