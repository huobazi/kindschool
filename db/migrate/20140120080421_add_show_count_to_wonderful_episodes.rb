class AddShowCountToWonderfulEpisodes < ActiveRecord::Migration
  def change
    add_column :wonderful_episodes, :show_count, :integer, :default => 0
  end
end
