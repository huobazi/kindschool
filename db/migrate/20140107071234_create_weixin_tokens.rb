class CreateWeixinTokens < ActiveRecord::Migration
    def migrate(direction)
    super
    # Create a default WeixinToken
    WeixinToken.create!(:number=>"weiyizixun") if direction == :up
  end
  def change
    create_table :weixin_tokens do |t|
      t.string :number
      t.string :appid
      t.string :secret
      t.string :access_token
      t.integer :expires_in,:default=>0
      t.datetime :expires_at
      t.timestamps
    end
  end
end
