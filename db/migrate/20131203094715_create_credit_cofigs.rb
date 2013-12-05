class CreateCreditCofigs < ActiveRecord::Migration
  def change
    create_table :credit_cofigs do |t|
      t.string :name
      t.string :number
      t.float :credit,:default=>0
      t.string :note

      t.timestamps
    end
  end
end
