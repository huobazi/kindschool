#encoding:utf-8
ActiveAdmin.register Role do
  menu :parent => "系统配置", :priority => 1

  collection_action :set_power_to_role, :method => :get, :title => "为该角色分配权限" do
    @role = Role.find_by_id(params[:role_id])
    @kind = Kindergarten.find_by_id(params[:kindergarten_id])
    @option_operates = OptionOperate.find_all_by_kindergarten_id(params[:kindergarten_id])
  end

  collection_action :update_allocation, :method => :post do
    if @role = Role.find_by_id(params[:role_id])
      ids = params[:operate] || []

      if ids.blank?
#        @role.option_operates.each do |operate|
#          operate.destroy
#        end
        @role.option_operates.destroy_all
      else
        delete_ids = []
        @role.option_operates.each do |option|
          unless ids.include?(option.id.to_s)
            @role.option_operates.destroy(option)
          end
        end
        @role.option_operates.destroy(delete_ids) unless delete_ids.blank?
      end

      ids.each do |option_operate_id|
        if option = OptionOperate.find_by_id_and_kindergarten_id(option_operate_id,@role.kindergarten_id)
          @role.option_operates << option unless @role.option_operates.include?(option)
        end
      end
      @role.save!
      flash[:success] = "操作成功"
      redirect_to :action => :show, :controller => "/admin/roles", :id => @role.id
    else
      flash[:error] = "角色不存在"
      redirect_to :action => :index, :controller => "/admin/roles"
    end
  end

  index do
    column :name do |item|
      link_to item.name, :controller => "/admin/roles", :action => :show, :id => item
    end
    column :kindergarten
    column :number
    column :admin_label
    column :note do |role|
      truncate(role.note)
    end
    default_actions
  end

  filter :name
  filter :kindergarten

  form do |f|
    f.inputs "角色" do
      f.input :kindergarten
      f.input :name, :required => true
      f.input :number
      f.input :admin
      f.input :note
    end
    f.actions
  end

  show do
    attributes_table do
      row :kindergarten
      row :name
      row :number
      row :admin_label
      row :note
      row :created_at
      row :updated_at

      div do
        br
        panel "拥有的权限" do
          unless role.option_operates.blank?
            options = role.option_operates.group_by{|option| option.operate && option.operate.parent ? option.operate.parent.name : ""}
            puts options
            table_for([]) do
              options.each do |k, v|
                tr :class => "odd" do
                  td k, :class => "tdColumn"
                  td do
                    v.each do |option_operate|
                      span option_operate.operate.name
                    end
                  end
                end
              end
            end
          end
        end
        ul do
          li do
            link_to "为该角色分配权限", :controller => "/admin/roles", :action => :set_power_to_role, :id => nil, :role_id => role.id, :kindergarten_id => role.kindergarten.id
          end
        end
      end

    end
  end
end
