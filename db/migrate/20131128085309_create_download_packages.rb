class CreateDownloadPackages < ActiveRecord::Migration
  def change
    create_table :download_packages do |t|
      t.integer :kindergarten_id
      t.string :name
      t.string :package

      t.timestamps
    end
  end
end
