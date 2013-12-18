#encoding:utf-8
ActiveAdmin.register Report do
  menu :parent => "幼儿园管理", :priority => 40

  index do
    column :informants
    column :process_label
    column :kindergarten
    # column :content do |report|
    #   truncate(report.content)
    # end
    column :resource_type
    column :resource_id
    column :resource_link do |report|
      link_to "查看举报对象的内容", :controller => "#{report.resource_type.downcase.pluralize}", :action => "show", :id => report.resource_id
    end
    default_actions
  end

  filter :content
  filter :process, :as => :select, :collection => Report::PROCESS.invert
  filter :informants
  filter :kindergarten
  filter :resource_type
  filter :resource_id
  filter :created_at

  show do
    attributes_table do
      row :informants
      row :process_label
      row :kindergarten
      row :content
      row :resource_type
      row :resource_id
    end
  end
end
