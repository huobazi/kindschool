class AddStorageToProducts < ActiveRecord::Migration
  def change
    add_column :products, :storage, :integer
  end
end
