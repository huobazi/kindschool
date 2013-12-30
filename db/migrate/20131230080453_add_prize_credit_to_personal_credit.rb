class AddPrizeCreditToPersonalCredit < ActiveRecord::Migration
  def change
    add_column :personal_credits, :prize_credit, :integer , :default=>0
  end
end
