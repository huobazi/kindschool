class CreatePageContents < ActiveRecord::Migration
  def change
    create_table :page_contents do |t|
      t.integer :kindergarten_id
      t.string :number
      t.string :name
      t.string :logo_url
      t.text :note
      t.timestamps
    end
  end
end
