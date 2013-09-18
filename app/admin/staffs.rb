#encoding:utf-8
ActiveAdmin.register Staff do
  menu :parent => "用户管理", :priority => 6

  controller do
    def new
      @staff = Staff.new()
      if @kindergarten = Kindergarten.find_by_id(params[:kindergarten_id])
        if params[:user_id]
          if (user = User.find_by_id_and_kindergarten_id(params[:user_id],params[:kindergarten_id]))
            if user.tp != 1
              flash[:notice] = "该帐号为非教职工"
              redirect_to :action => :index, :controller => "/admin/kindergartens"
              return
            end
            @staff.user_id = user.id
          else
            flash[:notice] = "指定的用户有误."
            redirect_to :action => :index,:controller=>"/admin/kindergartens"
            return
          end
        else
          @staff.user = User.new(:kindergarten_id=>@kindergarten.id,:tp=>1)
        end
      else
        flash[:notice] = "需要指定所属幼儿园."
        redirect_to :action => :index,:controller=>"/admin/kindergartens"
        return
      end
      new!
    end
  end

  controller do
    def show
      staff = Staff.find_by_id(params[:id])
      redirect_to :controller => "/admin/users", :action => :show, :id => staff.user_id
    end
  end

  index do
    column :user
    column :kindergarten_label
    column "微信id" do |staff|
      staff.try(:user).try(:weixin_code).blank? ? "已绑定" : "未绑定"
    end
    column "Weiyi Code" do |staff|
      staff.try(:user).try(:weixin_code).blank? ? "已绑定" : "未绑定"
    end
    column :created_at
    column :updated_at
    default_actions
  end
  
  filter :user_name,:as=>:string,:label=>"老师名字"
#  filter :user_kindergarten_id,:as=>:select,:label=>"幼儿园"
  filter :user_login,:as=>:string,:label=>"账号"
  filter :user_phone,:as=>:string,:label=>"电话"
  
  form do |f|
    f.inputs "帐号信息", :for => [:user, f.object.user || User.new] do |user|
        user.input :kindergarten_id,:as=>:hidden
        if (action_name == "new" || action_name == "create") && user.object.id.blank?
          user.input :login, :required => true
          user.input :email, :required => true
          user.input :password, :required => true
          user.input :password_confirmation, :required => true
        else
          user.input :login,:as=>:string, :input_html => { :disabled => true }, :required => true
        end
        user.input :name, :required => true
        user.input :phone, :required => true
        user.input :gender,:as=>:radio,:collection=>{"女"=>"M","男"=>"G"}, :required => true
        #        user.input :weixin_code
        user.input :tp_label, :as => :string, :input_html => { :disabled => true }
        user.input :kindergarten_label, :as => :string, :input_html => { :disabled => true }
        user.input :tp,:as=>:hidden
    end
    f.inputs "教职工信息" do
      f.input :birthday, :as => :just_datetime_picker
      f.input :come_in_at, :as => :just_datetime_picker
      f.input :card_code
      f.input :attendance_code
      f.input :education
      f.input :user_id,:as=>:hidden
    end
    f.actions
  end

end
