class CreateReports < ActiveRecord::Migration
  def change
    create_table :reports do |t|
      t.text :content
      t.integer :informants
      t.integer :process, :default => 0
      t.integer :resource_id
      t.string :resource_type

      t.timestamps
    end

    add_index :reports, :informants

    add_index :reports, ["resource_type", "resource_id"], :name => "report_resources"
  end

end
