class CreateWeixinShares < ActiveRecord::Migration
  def change
    #微信分享记录
    create_table :weixin_shares do |t|
      t.integer :weixin_databank_id
      t.datetime :send_at #推送时间
      t.boolean :visible, :default =>true
      t.timestamps
    end
  end
end
