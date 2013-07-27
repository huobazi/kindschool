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
      t.string :aliases_url #独立域名
      t.integer :sms_count ,:default=>0#可用短信数量
      t.integer :sms_user_count ,:default=>0#可收短信用户数量
      t.timestamps
    end
  end
end
