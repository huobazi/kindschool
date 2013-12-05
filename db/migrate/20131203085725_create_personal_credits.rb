class CreatePersonalCredits < ActiveRecord::Migration
  def change
    create_table :personal_credits do |t|
      t.integer :user_id
      t.integer :credit,:default=>0
      t.integer :kindergarten_id

      t.timestamps
    end
  end
end
