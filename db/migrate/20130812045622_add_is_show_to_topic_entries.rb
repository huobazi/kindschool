class AddIsShowToTopicEntries < ActiveRecord::Migration
  def change
    add_column :topic_entries, :is_show, :boolean, default: 1 # 0为删除,1为正常
  end
end
