class AddAccessedAtToWonderfulEpisodes < ActiveRecord::Migration
  def change
    add_column :wonderful_episodes, :accessed_at, :timestamp
  end
end
