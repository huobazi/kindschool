class AddRepeatToUsers < ActiveRecord::Migration
  def change
    add_column :users, :repeat, :boolean,:default=>false  #手机号码能否重复
  end
end
