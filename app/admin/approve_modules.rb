#encoding:utf-8
#幼儿园审核模块
ActiveAdmin.register ApproveModule do
	menu :parent => "幼儿园管理", :priority => 1
	index do
     column :kindergarten
     column :name
     column :number
     column :status
     default_actions
    end

    form do |f|
      f.inputs "活动相册信息" do
        f.input :kindergarten
        f.input :name, :required => true
        f.input :number
        f.input :status 
      end
        f.actions
    end

  show do |menu|
    attributes_table do
      row :kindergarten
      row :name
      row :number
      row :status
    end
  end

end