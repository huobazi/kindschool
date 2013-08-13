class CreateShrinkRecords < ActiveRecord::Migration
  def change
    create_table :shrink_records do |t|
      t.text :keywords  #SEO关键字
      t.text :description #SEO描述
      t.integer :kindergarten_id  #关联幼儿园
      t.string :url #预留字段

      t.timestamps
    end
  end
end
