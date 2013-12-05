class CreateMerchants < ActiveRecord::Migration
  def change
    create_table :merchants do |t|
      t.string :name
      t.text :note
      t.integer :status, :default => 0  #0正常,1关闭
      t.timestamps
    end
  end
end
