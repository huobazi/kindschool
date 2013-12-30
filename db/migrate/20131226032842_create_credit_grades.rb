class CreateCreditGrades < ActiveRecord::Migration
  def change
    create_table :credit_grades do |t|
      t.integer :tp
      t.string :name
      t.string :credit_num

      t.timestamps
    end

    add_index :credit_grades, :credit_num
  end
end
