class CreatePrizeLogs < ActiveRecord::Migration
  def change
    create_table :prize_logs do |t|
      t.integer :user_id
      t.integer :kindergarten_id
      t.string :resource_id
      t.integer :resource_id
      t.integer :status,:default=>0
      t.string :stage_credit

      t.timestamps
    end
  end
end
