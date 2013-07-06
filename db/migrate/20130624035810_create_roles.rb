class CreateRoles < ActiveRecord::Migration
  def self.up
    create_table :roles do |t|
      t.column :kindergarten_id,:integer
      t.column :name, :string
      t.column :number, :string
      t.column :admin, :boolean #是否是管理员
      t.column :note,:text                     #说明
      t.timestamps
    end
  end

  def self.down
    drop_table :roles
  end
end
