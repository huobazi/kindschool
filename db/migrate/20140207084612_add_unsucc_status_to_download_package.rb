class AddUnsuccStatusToDownloadPackage < ActiveRecord::Migration
  def change
    add_column :download_packages, :unsucc_status, :boolean,:default => false
  end
end
