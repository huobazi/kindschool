class AddInitStatusToKindergarten < ActiveRecord::Migration
  def change
    add_column :kindergartens, :init_status, :boolean,:default=>true
  end
end
