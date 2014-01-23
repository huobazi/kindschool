class AddKindZoneToKindergartens < ActiveRecord::Migration
  def change
    add_column :kindergartens, :kind_zone_id, :integer
  end
end
