class CreateUserSquads < ActiveRecord::Migration
  def change
    create_table :user_squads do |t|
      t.integer :user_id
      t.integer :squad_id

      t.timestamps
    end
  end
end
