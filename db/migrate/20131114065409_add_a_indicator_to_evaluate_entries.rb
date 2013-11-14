class AddAIndicatorToEvaluateEntries < ActiveRecord::Migration
  def change
    add_column :evaluate_entries, :a_indicator, :string
    add_column :evaluate_entries, :b_indicator, :string
  end
end
