#encoding:utf-8
class AddEnableCreditToKindergarten < ActiveRecord::Migration
  def change
    add_column :kindergartens, :enable_credit, :boolean,:default=>false
  end
end
