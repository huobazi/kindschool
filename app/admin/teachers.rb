#encoding:utf-8
ActiveAdmin.register Teacher do
  menu :parent => "幼儿园管理", :priority => 7
  collection_action :allocation, :method => :get, :title => "为教职工分配班级" do
    unless @staff = Staff.find_by_id(params[:staff_id])
      flash[:notice] = "没有该教职工"
      redirect_to :action => :index, :controller => "/admin/staffs"
      return
    end
    unless @kind = Kindergarten.find_by_id(params[:kindergarten_id])
      flash[:notice] = "需要指定所属幼儿园"
      redirect_to :action => :index, :controller => "/admin/kindergartens"
      return
    end
  end

  collection_action :update_allocation, :method => :post do
    if @staff = Staff.find_by_id(params[:staff_id])
      ids = params[:squad] || []
      #delete
      if ids.blank?
        @staff.teachers.each do |teacher|
          teacher.destroy
        end
      else
        @staff.teachers.each do |teacher|
          unless ids.include?(teacher.squad_id.to_s)
            teacher.destroy
          end
        end
      end
      #add
      ids.each do |squad_id|
        unless Teacher.find_by_squad_id_and_staff_id(squad_id,@staff.id)
          Teacher.create(:squad_id=>squad_id,:staff_id => @staff.id)
        end
      end

      flash[:success] = "操作成功"
      redirect_to :action => :show, :controller => "/admin/users",:id=>@staff.user_id, :anchor=>"show_teachers"
    else
      flash[:error] = "教职工不存在"
      redirect_to :action => :index, :controller => "/admin/kindergartens"
    end
  end

  collection_action :set_class_teacher, :method => :get do
    if (@teacher = Teacher.find_by_id(params[:teacher_id])) && @teacher.tp == 0
      if @un_class_teacher = Squad.find_by_id(params[:squad_id]).teachers
        @un_class_teacher.update_all(:tp => 0)
      end
      if @teacher.update_attributes(:tp => 1)
        flash[:success] = "操作成功"
        if params[:back_to_user_controller]
          redirect_to :controller => "/admin/users", :action => :show, :id => @teacher.staff.user.id
        else
          redirect_to :controller => "/admin/squads", :action => :show, :id => @teacher.squad_id
        end
      else
        flash[:error] = "操作失败"
        if params[:back_to_user_controller]
          redirect_to :controller => "/admin/users", :action => :show, :id => @teacher.staff.user.id
        else
          redirect_to :controller => "/admin/squads", :action => :show, :id => @teacher.squad_id
        end
      end
    else
      flash[:error] = "不能为将该负责人设置为班主任"
      redirect_to :controller => "/admin/squads", :action =>:index
    end
  end

  controller do
    def new
      @teacher = Teacher.new()
      if @kindergarten = Kindergarten.find_by_id(params[:kindergarten_id])
        @teacher.kindergarten = @kindergarten
        if params[:squad_id] && (squad = Squad.find_by_id_and_kindergarten_id(params[:squad_id],params[:kindergarten_id]))
          @teacher.squad = squad
        end
      else
        flash[:notice] = "需要指定所属幼儿园."
        redirect_to :action => :index,:controller=>"/admin/kindergartens"
        return
      end
      new!
    end
  end

  index do
    column :staff do |teacher|
      if teacher.staff && teacher.staff.user
        link_to teacher.staff.user.name, :controller => "/admin/users", :action => :show, :id => teacher.staff.user.id
      else
        link_to "该负责人的教职工不存在,请设置",:action=>:edit,:id=>teacher.id
      end
    end
    column :squad
    column :created_at
    column :updated_at
    default_actions
  end

end
