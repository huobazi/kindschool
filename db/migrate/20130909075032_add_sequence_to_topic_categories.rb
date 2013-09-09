class AddSequenceToTopicCategories < ActiveRecord::Migration
  def change
    add_column :topic_categories, :sequence, :integer, :default => 0
  end
end
