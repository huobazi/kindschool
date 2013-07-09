#encoding:utf-8
ActiveAdmin.register Squad do
  menu :parent => "幼儿园管理", :priority => 4

  controller do
    def new
      @squad = Squad.new()
      if kindergarten = Kindergarten.find_by_id(params[:kindergarten_id])
        @squad.kindergarten = kindergarten
        #如果有年级，则添加年级
        if params[:grade_id] && (grade = Grade.find_by_id_and_kindergarten_id(params[:grade_id],params[:kindergarten_id]))
          @squad.grade = grade
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
    column :name do |name|
      link_to name.name, :contorller => "/admin/squads", :action => "show", :id => name
    end
    column :kindergarten
    column :historyreview
    column :grade
    column :graduate
    column :sequence
    column :note
    column :created_at
    column :updated_at
    default_actions
  end

  filter :name
  filter :kindergarten

  form do |f|
    f.inputs "班级" do
      f.input :name, :required => true
      f.input :kindergarten_label, :as => :string, :input_html => { :disabled => true }
      f.input :historyreview
      f.input :grade,:as=>:select,:collection=>Hash[f.object.kindergarten.grades.map{|grade| ["#{grade.name}",grade.id]}]
      f.input :graduate
      f.input :sequence, :required => true,:as=>:number,:number=>:integer
      f.input :note
      f.input :kindergarten_id,:as=>:hidden
    end
    f.actions
  end
  show do |squad|
    attributes_table do
      row :name
      row :kindergarten
      row :historyreview
      row :grade
      row :graduate
      row :sequence
      row :note
      row :created_at
      row :updated_at


      div do
        br
        panel "学员信息" do
          unless squad.student_infos.blank?
            table_for(squad.student_infos) do |t|
              t.column("学员姓名") {|item| auto_link item.user}
              t.column("性别") {|item| item.user.gender == "M" ? "女" : "男" }
              t.column("电话") {|item| item.user.phone }
              t.column("家长姓名") {|item| item.guardian }
              tr :class => "odd" do
                td ""
                td ""
                td "总人数:", :style => "text-align: right;"
                td "#{squad.student_infos.count}人"
              end

            end
          else
            "未添加学员"
          end
        end
        ul do
          li do
            link_to "添加学员",:controller=>"/admin/student_infos",:kindergarten_id=>squad.kindergarten.id,:action=>:new,:id=>nil,:squad_id=>squad.id
          end
        end
      end
      div do
        br
        panel "负责人信息" do
          unless squad.teachers.blank?
            table_for(squad.teachers) do |t|
              t.column("名字") {|item| item.staff.user.name}
              t.column("班级") {|item| auto_link item.squad.name }
              t.column("身份证号码") {|item| item.staff.card_code}
              t.column("教育背景") {|item| item.staff.education}
              t.column("考勤卡号") {|item| item.staff.attendance_code}
              t.column("入职日期") {|item| item.staff.come_in_at}
              t.column("出生日期") {|item| item.staff.birthday}
              t.column("是否为班主任") {|item| item.tp == 1 ? "是" : "否"}
              t.column("操作") {|item| link_to "#{item.tp == 0 ? '设置为班主任' : nil}",url_for(:controller=>"/admin/teachers",:action=>:set_class_teacher,:teacher_id=>item.id, :squad_id => item.squad_id)}
            end
          else
            "未添加负责人"
          end
        end

        ul do
          li do
            link_to "添加负责人",:controller=>"/admin/staffs",:kindergarten_id=>squad.kindergarten.id,:action=>:new,:id=>nil,:squad_id=>squad.id
          end
        end
      end

      div do
        br
        panel "贴子列表" do
          unless squad.topics.blank?
            table_for(squad.topics) do |t|
              t.column("标题") {|item| item.title}
              t.column("发贴人") {|item| item.creater_id}
              tr :class => "odd" do
                td ""
                td "贴子总数", :style => "text-align: right;"
                td "#{squad.topics.count}"
                td ""
              end
            end
          else
            "未有贴子"
          end
        end

        ul do
          li do
            link_to "发表贴子", :controller => "/admin/topics", :action => :new, :kindergarten_id => squad.kindergarten.id, :squad_id => squad.id
          end
        end
      end
    end
  end
end
