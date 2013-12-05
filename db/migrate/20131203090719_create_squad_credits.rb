class CreateSquadCredits < ActiveRecord::Migration
  def change
    create_table :squad_credits do |t|
      t.integer :squad_id
      t.float :credit
      t.integer :kindergarten_id

      t.timestamps
    end
  end
end
