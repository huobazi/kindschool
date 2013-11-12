class AddResourceIdToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :resource_id, :integer
    add_column :messages, :resource_type, :string
  end
end
