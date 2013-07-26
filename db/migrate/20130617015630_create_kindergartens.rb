class CreateKindergartens < ActiveRecord::Migration
  def change
    create_table :kindergartens do |t|
      t.string :number
      t.string :name
      t.integer :template_id  #展示模板
      t.text :note
      t.integer :status,:default=>0
      t.integer :weixin_status,:default=>0
      t.string :weixin_code
      t.string :weixin_token
      t.string :logo
      t.string :latlng,:default=>""
      t.string :address
      t.timestamps
    end
  end
end
