class AddHintTpToKindergarten < ActiveRecord::Migration
  def change
    add_column :kindergartens, :hint_tp, :boolean,:default=>true
  end
end
