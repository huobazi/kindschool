#卷目录
class CreateEvaluateVtocs < ActiveRecord::Migration
  def change
    create_table :evaluate_vtocs do |t|
      t.integer :kindergarten_id
      t.integer :evaluate_enty_id
      t.string :name
      t.integer :sequence #排序
      t.timestamps
    end
  end
end
