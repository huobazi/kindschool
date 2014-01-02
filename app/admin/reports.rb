#encoding:utf-8
ActiveAdmin.register Report do
  menu :parent => "幼儿园管理", :priority => 40

  index do
    column :informants
    column :kindergarten
    # column :content do |report|
    #   truncate(report.content)
    # end
    column :resource_type_label
    column :resource_link do |report|
      link_to "查看举报对象的内容", :controller => "#{report.resource_type.underscore.pluralize}", :action => "show", :id => report.resource_id
    end
    column :process_label
    default_actions
  end

  filter :process, :as => :select, :collection => Report::PROCESS.invert
  filter :informants
  filter :kindergarten
  filter :resource_type
  filter :resource_id
  filter :created_at


  form do |f|
    f.inputs "举报的内容" do
      f.input :informants
      f.input :kindergarten
      f.input :resource_type_label, :as => :string, :input_html => { :disabled => true }
      f.input :resource_id, :as => :string, :input_html => { :disabled => true }
      f.input :process, :as => :select, :collection => Report::PROCESS.invert
    end
    f.actions
  end

  show do
    attributes_table do
      row :informants
      row :process_label
      row :kindergarten
      row :content
      row :resource_type_label
      row :resource_id
    end
  end
end
