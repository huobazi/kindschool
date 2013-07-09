class CreateContentPatterns < ActiveRecord::Migration
  def change
    create_table :content_patterns do |t|
      t.integer :kindergarten_id
      t.string :number
      t.text :content
      t.string :name

      t.timestamps
    end
  end
end
