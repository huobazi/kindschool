#encoding:utf-8
ActiveAdmin.register Template do
  menu :parent => "系统配置", :priority => 6

  collection_action :set_default_template, :method => :get do
    if kindergarten = Kindergarten.find_by_id(params[:kindergarten_id])
      if (@template = Template.find_by_id(params[:template_id])) && (@template.is_default == false)
        if @un_default_template = Template.where(:is_default => true)
          @un_default_template.update_all(:is_default => false)
        end
        if @template.update_attributes(:is_default => true) && kindergarten.update_attributes(:template_id => params[:template_id])
          flash[:success] = "操作成功"
          redirect_to :controller => "/admin/templates", :action => :index
        else
          flash[:error] = "操作失败"
          redirect_to :controller => "/admin/templates", :action => :index
        end
      else
        flash[:error] = "该模版已经是默认模版或不存在该模版"
        redirect_to :controller => "/admin/templates", :action => :index
      end
    else
      flash[:notice] = "需要指定所属幼儿园."
      redirect_to :action => :index,:controller=>"/admin/kindergartens"
      return
    end
  end

  index do
    column :name do |item|
      link_to item.name, :controller => "/admin/templates", :action => :show, :id => item.id
    end
    column :number
    column :is_default do |item|
      item.is_default ? "是" : "否"
    end
    column :image_url
    actions do |t|
      if t.is_default == false
        link_to "设为默认模版", :controller => "/admin/templates", :action => :set_default_template, :template_id => t.id, :kindergarten_id => params[:kindergarten_id]
      end
    end
  end

  filter :name
  filter :number

  form do |f|
    f.inputs "模板信息" do
      f.input :number, :required => true
      f.input :name, :required => true
      f.input :is_default
      f.input :image_url
    end
    f.actions
  end

  show do |template|
    attributes_table do
      row :number
      row :name
      row :is_default
      row "图片地址" do
        template.image_url
      end
      row :image_url do
        img :src=>template.image_url,:width=>"700px"
      end
    end
  end
end

