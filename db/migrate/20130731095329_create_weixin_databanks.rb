class CreateWeixinDatabanks < ActiveRecord::Migration
  def change
    #微信资料库
    create_table :weixin_databanks do |t|
      t.string :title
      t.text :content
      t.integer :creater_id
      t.integer :category_id  #分类
      t.boolean :visible, :default =>true
      t.timestamps
    end
  end
end
