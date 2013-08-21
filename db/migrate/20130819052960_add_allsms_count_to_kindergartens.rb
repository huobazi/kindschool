class AddAllsmsCountToKindergartens < ActiveRecord::Migration
  def change
    add_column :kindergartens, :allsms_count, :integer, :default => 30  #设置每个月群发所有人短信数量
    add_column :kindergartens, :open_allsms, :boolean, :default => true  #设置每个月群发是否限制数量
  end
end
