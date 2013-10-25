class CreateHelpCategories < ActiveRecord::Migration
  def change
    create_table :help_categories do |t|
      t.string :name
      t.string :code
      t.string :remark
      t.integer :parent_id
      t.integer :tp_id
      t.integer :help_movie_id
      # t.integer :lft
      # t.integer :rgt
      # t.integer :level

      t.timestamps
    end
  end
end
