class CreateWeixinShareUsers < ActiveRecord::Migration
  def change
    #分享的人和阅读记录
    create_table :weixin_share_users do |t|
      t.integer :weixin_share_id
      t.integer :user_id
      t.integer :kindergarten_id
      t.boolean :read_status, :default => false #阅读状态
      t.datetime :read_at #阅读时间
      t.timestamps
    end
  end
end
