#评估管理方案39条细则
class CreateEvaluateEnties < ActiveRecord::Migration
  def change
    create_table :evaluate_enties do |t|
      t.integer :kindergarten_id
      t.integer :evaluate_id
      t.string :name
      t.string :article_case #案条
      t.integer :sequence #排序
      t.text :note  #描述
      t.text :self_note #自评说明
      t.timestamps
    end
  end
end
