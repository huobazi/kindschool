class AddRenameToOptionOperates < ActiveRecord::Migration
  def change
    add_column :option_operates, :rename, :string
  end
end
