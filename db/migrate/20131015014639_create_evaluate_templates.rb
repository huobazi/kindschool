#自评模板
class CreateEvaluateTemplates < ActiveRecord::Migration
  def change
    create_table :evaluate_templates do |t|
      t.integer :tp, :default=>0
      t.string :template_url
      t.string :name
      t.text :note
      t.timestamps
    end
  end
end
