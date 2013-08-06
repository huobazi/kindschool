class CreateWeixinShares < ActiveRecord::Migration
  def change
    #微信分享记录
    create_table :weixin_shares do |t|
      t.integer :weixin_databank_id
      t.integer :send_range, :default =>0 #0为学生，1为学生和老师
      t.datetime :send_date #推送时间
      t.boolean :visible, :default =>true
      t.timestamps
    end
  end
end
