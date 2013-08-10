class CreateTextSets < ActiveRecord::Migration
  def change
    create_table :text_sets do |t|
      t.text :content
      t.timestamps
    end
  end
end
