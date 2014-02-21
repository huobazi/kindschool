class CreateWeixinCodes < ActiveRecord::Migration
  def migrate(direction)
    super
    if direction == :up
      User.all.each do |record|
        unless record.weiyi_code.blank?
          weixin_code = WeixinCode.new
          weixin_code.user_id = record.id
          weixin_code.weixin_code = record.weiyi_code
          weixin_code.kindergarten_id = record.kindergarten_id
          weixin_code.weixin_tp = 1
          weixin_code.save
        end
        unless record.weixin_code.blank?
          weiyi_code = WeixinCode.new
          weiyi_code.user_id = record.id
          weiyi_code.weixin_code = record.weixin_code
          weiyi_code.kindergarten_id = record.kindergarten_id
          weiyi_code.weixin_tp = 0
          weiyi_code.save
        end
      end
    end
  end
  def change
    create_table :weixin_codes do |t|
      t.string :weixin_code
      t.integer :weixin_tp
      t.integer :user_id
      t.integer :kindergarten_id
      t.timestamps
    end
  end
end
