class CreateHelpMovies < ActiveRecord::Migration
  def change
    create_table :help_movies do |t|
      t.string :name
      t.text :content
      # t.integer :help_category_id

      t.timestamps
    end
  end
end
