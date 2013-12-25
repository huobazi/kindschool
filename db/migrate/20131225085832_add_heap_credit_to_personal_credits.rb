class AddHeapCreditToPersonalCredits < ActiveRecord::Migration
  def change
    add_column :personal_credits, :heap_credit, :integer
    PersonalCredit.reset_column_information
    PersonalCredit.all.each do |personal_credit|
      personal_credit.update_attribute(:heap_credit, personal_credit.credit)
    end
  end
end
