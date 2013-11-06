class CreateGardenActivities < ActiveRecord::Migration
  def change
    create_table :garden_activities do |t|
      t.string :title
      t.text :content
      t.timestamp :start_at
      t.timestamp :end_at
      t.text :note
      t.timestamps
    end
  end
end
