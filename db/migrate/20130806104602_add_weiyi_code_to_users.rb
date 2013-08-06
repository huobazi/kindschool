class AddWeiyiCodeToUsers < ActiveRecord::Migration
  def change
    add_column :users, :weiyi_code, :string
  end
end
