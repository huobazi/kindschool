class CreateDeanEmails < ActiveRecord::Migration
  def change
    create_table :dean_emails do |t|
      t.integer :kindergarten_id
      t.integer :status , :default => 0  #状态，0、新增；1、已答复
      t.integer :user_id #家长id，可能没有
      t.string :user_name  #家长姓名
      t.string :user_email  #家长邮箱
      t.string :title    #标题
      t.text :content    #家长留言
      t.integer :sender_id #回复人id
      t.text :return_content   #答复内容
      t.boolean :visible , :default => false  #是否显示
      t.timestamps
    end
  end
end
