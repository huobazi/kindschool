class CreateAudios < ActiveRecord::Migration
  def change
    create_table :audios do |t|
      t.integer :kindergarten_id
      t.integer :user_id
      t.string :audio_url

      t.timestamps
    end
  end
end
