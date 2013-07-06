class CreateCareerStrategies < ActiveRecord::Migration
  def change
    create_table :career_strategies do |t|
      t.integer :kindergarten_id
      t.boolean :graduation, :default => 0 #0 为未毕业,1为已经毕业
      t.integer :add_squad
      t.integer :from_id
      t.integer :to_id

      t.timestamps
    end
  end
end
