class CreateContentEntries < ActiveRecord::Migration
  def change
    create_table :content_entries do |t|
      t.integer :page_content_id
      t.string :title
      t.string :number
      t.text :content
      t.string :resource_type
      t.integer :resource_id

      t.timestamps
    end
  end
end
