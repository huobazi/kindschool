class AddLftToHelpCategories < ActiveRecord::Migration
  def change
  	add_column :help_categories, :lft, :integer
    add_column :help_categories, :rgt, :integer
    add_column :help_categories, :level, :integer
  end
end
