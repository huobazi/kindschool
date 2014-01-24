class RemoveKindZoneIdFromPolicies < ActiveRecord::Migration
  def up
    remove_column :policies, :kind_zone_id
  end

  def down
    add_column :policies, :kind_zone_id, :integer
  end
end
