class AddKindIdToReports < ActiveRecord::Migration
  def change
    add_column :reports, :kindergarten_id, :integer
  end
end
