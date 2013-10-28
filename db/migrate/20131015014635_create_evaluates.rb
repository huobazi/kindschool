#评估管理，主表，与幼儿园一对一
class CreateEvaluates < ActiveRecord::Migration
  def change
    create_table :evaluates do |t|
      t.integer :kindergarten_id
      t.string :note
      t.timestamps
    end
  end
end
