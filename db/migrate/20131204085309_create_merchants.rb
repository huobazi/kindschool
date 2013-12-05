class CreateMerchants < ActiveRecord::Migration
  def change
    create_table :merchants do |t|
      t.string :name
      t.text :note
      t.integer :logo_id
      t.timestamps
    end
  end
end
