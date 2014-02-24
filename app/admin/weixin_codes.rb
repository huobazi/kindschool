#encoding:utf-8
ActiveAdmin.register WeixinCode do
  menu :parent => "幼儿园管理", :priority => 41

  controller do
    def new
      @weixin_code = WeixinCode.new()
      if kindergarten = Kindergarten.find_by_id(params[:kindergarten_id])
        @weixin_code.kindergarten = kindergarten
      else
        flash[:notice] = "需要指定所属幼儿园."
        redirect_to :action => :index,:controller=>"/admin/kindergartens"
        return
      end
      new!
    end
  end

  index do
    column :weixin_code
    column :user
    column :kindergarten
    column :tp_label
    default_actions
  end

  filter :kindergarten
  filter :user_name, :as => :string
  filter :weixin_code
  filter :weixin_tp, :as => :select, :collection => WeixinCode::TP_DATA.invert

  form do |f|
    f.inputs "更改微信code" do
      f.input :weixin_code, :required => true
      f.input :user, :required => true
      f.input :kindergarten
    end
    f.actions
  end

  show do |menu|
    attributes_table do
      row :weixin_code
      row :user
      row :kindergarten
      row :tp_label
    end
  end
end
