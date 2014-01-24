class CreateKindZonesPoliciesJoinTable < ActiveRecord::Migration
  def change
    create_table :kind_zones_policies, id: false do |t|
      t.integer :kind_zone_id
      t.integer :policy_id
    end
  end
end
