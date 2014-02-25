class AddBaiduSeoToKindergarten < ActiveRecord::Migration
  def change
    add_column :kindergartens, :baidu_seo, :string
  end
end
