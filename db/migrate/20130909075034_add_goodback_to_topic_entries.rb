class AddGoodbackToTopicEntries < ActiveRecord::Migration
  def change
    add_column :topic_entries, :goodback, :boolean, :default => false
  end
end
