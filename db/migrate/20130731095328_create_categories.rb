class CreateCategories < ActiveRecord::Migration
  def change
    #资料库分类
    create_table :categories do |t|
      t.string :name
      t.integer :tp, :default =>0# 0微信资料库，1点评资料库，2家长关注
      t.boolean :visible, :default =>true
    end
  end
end
