class AddStatusToDownloadPackage < ActiveRecord::Migration
  def change
    add_column :download_packages, :status, :boolean
  end
end
