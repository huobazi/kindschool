class CreateSysLogs < ActiveRecord::Migration
  def change
    create_table :sys_logs do |t|
      t.integer :kindergarten_id    #幼儿园id
      t.integer :user_id            #记录操作人员
      t.string :url_options         #controller和action
      t.string :method              #请求的方式
      t.string :original_url        #请求的地址
      t.string :remote_ip           #请求的ip
      t.text :url_chinese           #日志的中文意思text
      t.text :url_params            #提交参数text
      t.text :node                  #描述text

      t.timestamps                  #会自动生成created_at和updated_at字段
    end
  end
end
