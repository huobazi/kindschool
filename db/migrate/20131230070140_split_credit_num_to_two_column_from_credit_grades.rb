class SplitCreditNumToTwoColumnFromCreditGrades < ActiveRecord::Migration
  def up
    remove_column :credit_grades, :credit_num
    add_column :credit_grades, :down_credit, :integer
    add_column :credit_grades, :up_credit, :integer
    add_index :credit_grades, :down_credit
    add_index :credit_grades, :up_credit
  end

  def down
    remove_index :credit_grades, :up_credit
    remove_index :credit_grades, :down_credit
    remove_column :credit_grades, :up_credit
    remove_column :credit_grades, :down_credit
    add_column :credit_grades, :credit_num, :string
  end

end
