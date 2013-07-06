#encoding:utf-8
ActiveAdmin.register Grade do
  menu :parent => "幼儿园管理", :priority => 3
  controller do
    def new
      @grade = Grade.new()
      if @kindergarten = Kindergarten.find_by_id(params[:kindergarten_id])
        @grade.kindergarten = @kindergarten
      else
        flash[:notice] = "需要指定所属幼儿园."
        redirect_to :action => :index,:controller=>"/admin/kindergartens"
        return
      end
      new!
    end
  end
  
  index do
    column :name
    column :kindergarten
    column :sequence
    column :staff
    column :note
    column :created_at
    column :updated_at
    default_actions
  end

  filter :name
  filter :kindergarten

  form do |f|               
    f.inputs "年级" do
      f.input :name, :required => true
      f.input :kindergarten_label, :as => :string, :input_html => { :disabled => true }
      f.input :sequence, :required => true,:as=>:number,:number=>:integer
      f.input :staff
      f.input :note
      f.input :kindergarten_id,:as=>:hidden
    end
    f.actions
  end
  show do |grade|
    attributes_table do
      row :name
      row :kindergarten
      row :sequence
      row :staff
      row :note
      row :created_at
      row :updated_at
      div do
        br
        panel "班级信息" do
          unless grade.squads.blank?
            table_for(grade.squads) do |t|
              t.column("年级") {|item| grade.name }
              t.column("班级") {|item| auto_link item }
              t.column("班级人数") {|item| link_to "#{item.student_infos.count}人",:controller=>"/admin/student_infos",:action=>:index,"q[kindergarten_id_eq]"=>grade.kindergarten.id,"q[squad_name_contains]"=>item.name }
              t.column("操作") {|item| link_to "添加学员",:controller=>"/admin/student_infos",:kindergarten_id=>grade.kindergarten.id,:action=>:new,:id=>nil,:squad_id=>item.id }
              tr :class => "odd" do
                td ""
                td "总人数:", :style => "text-align: right;"
                td "#{grade.student_infos_count}人"
                td ""
              end
            end
          end
        end
        ul do
          li do
            link_to "添加班级",:controller=>"/admin/squads",:kindergarten_id=>grade.kindergarten.id,:action=>:new,:id=>nil,:grade_id=>grade.id
          end
        end
      end
    end

  end
end
