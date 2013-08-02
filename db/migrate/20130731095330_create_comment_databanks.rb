class CreateCommentDatabanks < ActiveRecord::Migration
  def change
    #点评资料库
    create_table :comment_databanks do |t|
      t.text :content
      t.integer :user_id
      t.integer :category_id  #分类
      t.boolean :visible, :default =>true
      t.timestamps
    end
  end
end
