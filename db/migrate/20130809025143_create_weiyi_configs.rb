class CreateWeiyiConfigs < ActiveRecord::Migration
  def change
    create_table :weiyi_configs do |t|
      t.string :number
      t.text :content
    end
  end
end
