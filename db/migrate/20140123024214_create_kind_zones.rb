class CreateKindZones < ActiveRecord::Migration
  def change
    create_table :kind_zones do |t|
      t.string :name
      t.string :code
      t.string :remark
      t.integer :parent_id
      t.integer :lft
      t.integer :rgt
      t.integer :level

      t.timestamps
    end
  end
end
