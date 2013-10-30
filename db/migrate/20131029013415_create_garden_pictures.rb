class CreateGardenPictures < ActiveRecord::Migration
  def change
    create_table :garden_pictures do |t|
      t.string :title
      t.string :tp
      t.timestamps
    end
  end
end
