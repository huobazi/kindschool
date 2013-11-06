class CreateGardenNews < ActiveRecord::Migration
  def change
    create_table :garden_news do |t|
      t.string :title
      t.text :content
      t.integer :creater_id
      t.string :note
      t.integer :show_count , :default => 0 #浏览次数
      t.timestamps
    end
  end
end
