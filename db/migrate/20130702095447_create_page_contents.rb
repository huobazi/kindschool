class CreatePageContents < ActiveRecord::Migration
  def change
    create_table :page_contents do |t|
      t.integer :kindergarten_id
      t.string :number
      t.string :name
      t.string :logo_url
      t.text :note
      t.integer :tp,:default=>0 #用于区别于页面类型,tp=1表示官网
      t.timestamps
    end
  end
end
