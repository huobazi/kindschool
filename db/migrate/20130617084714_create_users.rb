class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :number
      t.string :login
      t.string :email
      t.string :name
      t.text :note
      t.integer :kindergarten_id
      t.integer :tp,:default=>0  #0是家长(学员)，1是教职工，2是管理员
      t.string :status,:default=>"start"
      t.string :logo
      t.string :crypted_password, :limit => 40
      t.string :salt, :limit => 40
      t.integer :role_id
      t.string :remember_token
      t.datetime :remember_token_expires_at
      t.string :gender, :default => 'M'
      t.string :phone, :default => ''
      t.integer :area_id
      t.string :weixin_code
      t.string :token_key
      t.string :token_secret
      t.datetime :token_at
      t.timestamps
    end
    add_index :users, :email, :unique => true
  end
end
