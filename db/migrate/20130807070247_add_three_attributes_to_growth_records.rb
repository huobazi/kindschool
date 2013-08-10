class AddThreeAttributesToGrowthRecords < ActiveRecord::Migration
  def change
    add_column :growth_records, :siesta, :string
    add_column :growth_records, :dine, :string
    add_column :growth_records, :reward, :integer, :default => 1
  end
end
