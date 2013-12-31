class CreatePrizes < ActiveRecord::Migration
  def change
    create_table :prizes do |t|
      t.string :name
      t.string :beep
      t.string :beep_url
      t.text :content
      t.string :content_url
      t.integer :status,:default=>0

      t.timestamps
    end
  end
end
