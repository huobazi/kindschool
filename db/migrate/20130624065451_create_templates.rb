#常用功能
class CreateTemplates < ActiveRecord::Migration
  def self.up
    create_table :templates do |t|
      t.string :name  #名称
      t.string :number  #编号
      t.boolean :is_default,:default=> 0 #是否默认
      t.string :image_url  #展示图片地址
    end
  end

  def self.down
    drop_table :templates
  end
end
