#办公管理资源表
class CreateEvaluateAssets < ActiveRecord::Migration
  def change
    create_table :evaluate_assets do |t|
      t.integer :kindergarten_id
      t.integer :user_id
      t.integer :resource_id
      t.string :resource_type
      t.string :avatar  #存储地址
      t.string :file_name
      t.decimal :file_size, :precision => 12, :scale=>4, :default=>0
      t.timestamps
    end
  end
end
