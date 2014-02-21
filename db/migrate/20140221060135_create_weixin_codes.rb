class CreateWeixinCodes < ActiveRecord::Migration
  def change
    create_table :weixin_codes do |t|
      t.string :weixin_code
      t.integer :weixin_tp
      t.integer :user_id
      t.integer :kindergarten_id

      t.timestamps
    end
    WeixinCode.reset_column_information
    User.all.each do |u|
      if u.weiyi_code
        w1 = WeixinCode.new
        w1.user_id = u.id
        w1.weixin_code = u.weiyi_code
        w1.kindergarten_id = u.kindergarten_id
        w1.weixin_tp = 1
        w1.save

      end

      if u.weixin_code
        w2 = WeixinCode.new
        w2.user_id = u.id
        w2.weixin_code = u.weixin_code
        w2.kindergarten_id = u.kindergarten_id
        w2.weixin_tp = 0
        w2.save
      end
    end
  end
end
