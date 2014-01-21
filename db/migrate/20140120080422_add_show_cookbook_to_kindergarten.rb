class AddShowCookbookToKindergarten < ActiveRecord::Migration
  def change
    add_column :kindergartens, :show_cookbook, :boolean, :default => false
  end
end
