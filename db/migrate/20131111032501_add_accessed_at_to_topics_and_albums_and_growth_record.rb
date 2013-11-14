class AddAccessedAtToTopicsAndAlbumsAndGrowthRecord < ActiveRecord::Migration
  def change
    add_column :topics, :accessed_at, :timestamp
    add_column :albums, :accessed_at, :timestamp
    add_column :growth_records, :accessed_at, :timestamp
  end
end
