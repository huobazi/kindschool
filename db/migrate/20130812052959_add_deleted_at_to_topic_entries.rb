class AddDeletedAtToTopicEntries < ActiveRecord::Migration
  def change
    add_column :topic_entries, :deleted_at, :timestamp
  end
end
