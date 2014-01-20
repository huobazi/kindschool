class CreateWonderfulEpisodes < ActiveRecord::Migration
  def change
    create_table :wonderful_episodes do |t|
      t.string :title
      t.integer :kindergarten_id
      t.integer :squad_id
      t.integer :user_id
      t.string :url_address
      t.boolean :is_top, :default => 0, :null => false

      t.timestamps
    end
  end
end
