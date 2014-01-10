class AddAudioToGrowthRecords < ActiveRecord::Migration

  def change
    add_column :growth_records, :audio_turn, :string
  end
end
