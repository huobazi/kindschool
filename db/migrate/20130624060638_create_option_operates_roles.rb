class CreateOptionOperatesRoles < ActiveRecord::Migration
  def self.up
    create_table :option_operates_roles ,:id=>false do |t|
      t.column :role_id,:integer
      t.column :option_operate_id,:integer
    end
  end

  def self.down
    drop_table :option_operates_roles
  end
end
