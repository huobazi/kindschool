class CreatePrizes < ActiveRecord::Migration
  def change
    create_table :prizes do |t|
      t.string :name
      t.string :beep
      t.string :beep_url
      t.string :content
      t.string :content_url
      t.integer :status

      t.timestamps
    end
  end
end
