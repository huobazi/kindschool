class AddRoleToAdminUsers < ActiveRecord::Migration
  def change
    add_column :admin_users, :role_name, :string, :default => "member"
  end
end
