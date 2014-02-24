class AddCreditStatusToKindergarten < ActiveRecord::Migration
  def change
    add_column :kindergartens, :credit_status, :integer,:default => 0
  end
end
