#encoding:utf-8
ActiveAdmin.register OptionOperate do
  menu :parent => "系统配置", :priority => 5

  collection_action :add_functional_to_kind, :method => :get, :title => "为幼儿园分配权限" do
    @kind = Kindergarten.find_by_id(params[:kindergarten_id])
    @option_operate = OptionOperate.new
    @operate_root = Operate.find_by_name("root")
  end

  collection_action :update_functional, :method => :post do
    if @kind = Kindergarten.find_by_id(params[:kindergarten_id])
      ids = params[:operate] || []
      OptionOperate.transaction do 
        if ids.blank?
          @kind.option_operates.each do |operate|#delete_all()
              operate.destroy
          end
        else
          @kind.option_operates.each do |option|
            unless ids.include?(option.operate_id.to_s)
              option.delete
            end
          end
        end
        ids.each do |operate_id|
          if operate = Operate.find_by_id(operate_id)
            unless OptionOperate.find_by_operate_id_and_kindergarten_id(operate.id,@kind.id)
              OptionOperate.create!(:operate_id=>operate.id,:kindergarten_id=>@kind.id)
            end
          end
        end
        @kind.save!
      end
      flash[:success] = "操作成功"
      redirect_to :action => :show, :controller => "/admin/kindergartens", :id => @kind.id
    else
      flash[:error] = "幼儿园不存在"
      redirect_to :action => :index, :controller => "/admin/kindergartens"
    end
  end

  index do
    column :kindergarten
    column :operate
    column :visible
    default_actions
  end

  form do |f|
    f.inputs "幼儿园常用功能配置" do
      f.input :kindergarten, :required => true
      f.input :operate, :required => true
      f.input :visible
    end
    f.actions
  end

  show do |menu|
    attributes_table do
      row :kindergarten
      row :operate
      row :visible
    end
  end
end
