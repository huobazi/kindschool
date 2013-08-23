#encoding:utf-8
ActiveAdmin.register User do
  menu :parent => "幼儿园管理", :priority => 2
  controller do
    def new
      if params[:id]
        @user = User.find(params[:id])
      else
        @user = User.new()
      end

      @user.tp = 2 if params[:tp] == "admin"
      if @kindergarten = Kindergarten.find_by_id(params[:kindergarten_id])
        if @kindergarten.admin
          flash[:notice] = "幼儿园管理员已经存在."
          redirect_to :action => :show,:controller=>"/admin/users",:id=>@kindergarten.admin.id
          return
        end
        @user.kindergarten = @kindergarten
      else
        flash[:notice] = "需要指定所属幼儿园."
        return
      end
    end
  end
  
  index do
    column :name
    column :login do |user|
      link_to user.login, admin_user_path(user),:class=>"member_link view_link"
    end
    column :email
    column :kindergarten
    column :gender do |user|
      User::GENDER_DATA[user.gender]
    end
    column :tp do |user|
      User::TP_DATA[user.tp.to_s]
    end
    column :phone
    column :weixin_code
    column :created_at
    column :updated_at
    column :is_send
    column :is_receive
    default_actions
  end


  filter :email
  filter :name
  filter :login
  filter :phone
  filter :gender, :as => :select, :collection => {"女"=>"M","男"=>"G"}

  form do |f|
    f.inputs "用户" do
      if action_name == "new" || action_name == "create"
        f.input :login, :required => true
        f.input :password, :required => true
        f.input :password_confirmation, :required => true
      else
        f.input :login,:as=>:string, :input_html => { :disabled => true }, :required => true
      end
      f.input :email
      f.input :name, :required => true
      f.input :phone, :required => true
      f.input :role, :as=>:select,:collection=>Hash[f.object.kindergarten.roles.collect{|role| [role.name,role.id]}]
#      f.input :role, :as => :string, :input_html => { :disabled => true }
      f.input :gender,:as=>:radio,:collection=>{"女"=>"M","男"=>"G"}, :required => true
      f.input :weixin_code
      f.input :weiyi_code
      f.input :tp_label, :as => :string, :input_html => { :disabled => true }
      f.input :kindergarten_label, :as => :string, :input_html => { :disabled => true }
      f.input :tp,:as=>:hidden
      f.input :is_send
      f.input :is_receive
      f.input :kindergarten_id,:as=>:hidden
      f.input :kindergarten_id,:as=>:hidden, :input_html => { :name => "kindergarten_id" }
    end
    f.actions
  end
  show do |user|
    attributes_table do
      row :name
      row :login
      row :email
      row :phone
      row :role
      row :gender do
        User::GENDER_DATA[user.gender]
      end
      row :kindergarten
      row :tp_label
      row :weixin_code
      row :weiyi_code
      row :created_at
      row :updated_at
      row :is_send
      row :is_receive
      div do
        br
        if user.tp == 0
          if student = user.student_info
            panel "学员信息" do
              table_for([]) do
                tr :class => "odd" do
                  td "年级:",:class=>"tdColumn"
                  td student.squad.grade_label
                  td "班级:",:class=>"tdColumn"
                  td student.squad.name
                end
                tr do
                  td "出生日期:",:class=>"tdColumn"
                  td (student.birthday ? student.birthday.to_short_datetime : "")
                  td "入园时间:",:class=>"tdColumn"
                  td (student.come_in_at ? student.come_in_at.to_short_datetime : "")
                end
                tr :class => "odd" do
                  td "证件类别:",:class=>"tdColumn"
                  td student.card_category_label
                  td "证件号:",:class=>"tdColumn"
                  td student.card_code
                end
                tr do
                  td "监护人名字:",:class=>"tdColumn"
                  td student.guardian
                  td "监护人证件类别:",:class=>"tdColumn"
                  td student.guardian_card_category_label
                end
                tr :class => "odd" do
                  td "国籍:",:class=>"tdColumn"
                  td student.nationality
                  td "民族:",:class=>"tdColumn"
                  td student.nation
                end
                tr do
                  td "港澳台侨:",:class=>"tdColumn"
                  td student.overseas_chinese_label
                  td "户口性质:",:class=>"tdColumn"
                  td student.household_label
                end
                tr :class => "odd" do
                  td "出生地:",:class=>"tdColumn"
                  td student.birthplace
                  td "籍贯:",:class=>"tdColumn"
                  td student.native
                end
                tr do
                  td "户口所在地:",:class=>"tdColumn"
                  td student.domicile_place
                  td "家庭地址:",:class=>"tdColumn"
                  td student.family_address
                end
                tr :class => "odd" do
                  td "是否寄宿生:",:class=>"tdColumn"
                  td (student.lodging ? "是" : "否")
                  td "是否独生子女:",:class=>"tdColumn"
                  td (student.only_child ? "是" : "否")
                end
                tr do
                  td "是否孤儿:",:class=>"tdColumn"
                  td (student.orphan ? "是" : "否")
                  td "是否留守儿童:",:class=>"tdColumn"
                  td (student.leftover_children ? "是" : "否")
                end
                tr :class => "odd" do
                  td "是否进城务工人员子女:",:class=>"tdColumn"
                  td (student.employofficialt ? "是" : "否")
                  td "是否低保:",:class=>"tdColumn"
                  td (student.insured ? "是" : "否")
                end
                tr do
                  td "是否接受资助:",:class=>"tdColumn"
                  td (student.subsidize ? "是" : "否")
                  td "是否残疾儿童:",:class=>"tdColumn"
                  td (student.deformity ? "是" : "否")
                end
                tr :class => "odd" do
                  td "残疾儿童类型:",:class=>"tdColumn"
                  td student.deformity_category
                  td "住房性质:",:class=>"tdColumn"
                  td student.housing_label
                end
                tr do
                  td "家中子女数:",:class=>"tdColumn"
                  td student.brothers
                  td "本人第几胎:",:class=>"tdColumn"
                  td student.children_number
                end
              end
            end

            panel "家庭信息" do
              table_for([]) do
                tr :class => "odd" do
                  td "关系:",:class=>"tdColumn"
                  td student.family_ties
                  td "姓名:",:class=>"tdColumn"
                  td student.family_name
                end
                tr do
                  td "政治面貌:",:class=>"tdColumn"
                  td student.politics_status
                  td "出生日期:",:class=>"tdColumn"
                  td (student.family_birthday ? student.family_birthday.to_short_datetime : "")
                end
                tr :class => "odd" do
                  td "职业:",:class=>"tdColumn"
                  td student.profession
                  td "职务:",:class=>"tdColumn"
                  td student.duties
                end
                tr do
                  td "工作单位:",:class=>"tdColumn"
                  td student.working
                  td "户籍类型:",:class=>"tdColumn"
                  td student.family_register
                end
                tr :class => "odd" do
                  td "移动电话:",:class=>"tdColumn"
                  td student.family_phone
                  td "电子邮箱:",:class=>"tdColumn"
                  td student.family_email
                end
                tr do
                  td "父母在深连续居住时间:",:class=>"tdColumn"
                  td student.living_time
                  td "婚姻状况:",:class=>"tdColumn"
                  td student.family_marital
                end
                tr :class => "odd" do
                  td "学历:",:class=>"tdColumn"
                  td student.education
                  td "社会保险箱:",:class=>"tdColumn"
                  td student.safe_box
                end
              end
            end
          else
            ul do
              li do
                link_to "添加学员信息",:controller=>"/admin/student_infos",:kindergarten_id=>user.kindergarten_id,:action=>:new,:id=>nil,:user_id=>user.id
              end
            end
          end
        elsif user.tp == 1
          div do
            br
            if staff = user.staff
              panel "教职工信息" do
                table_for([]) do
                  tr :class => "odd" do
                    td "姓名", :class => "tdColumn"
                    td staff.user.name
                    td "身份证号:", :class => "tdColumn"
                    td staff.card_code
                  end

                  tr do
                    td "教育背景", :class => "tdColumn"
                    td staff.education
                    td "考勤卡号", :class => "tdColumn"
                    td staff.attendance_code
                  end

                  tr :class => "odd" do
                    td "入职时间", :class => "tdColumn"
                    td (staff.come_in_at ? staff.come_in_at.to_short_datetime : "")
                    td "出生日期", :class => "tdColumn"
                    td (staff.birthday ? staff.birthday.to_short_datetime : "")
                  end
                end
                ul do
                  li do
                    link_to "为该教职工分配班级", :controller => "/admin/teachers",
                      :action => :allocation, :kindergarten_id =>
                      user.kindergarten_id, :staff_id => user.staff
                  end
                end
              end
              if !staff.teachers.blank?
                panel "负责的班级",:id=>:show_teachers do
                  table_for(staff.teachers) do |t|
                    t.column("年级") {|item| item.squad && item.squad.grade ? (auto_link item.squad.grade) : "无"}
                    t.column("班级") {|item| item.squad ? (auto_link item.squad) : "无"}
                    t.column("是否班主任") {|item| item.tp == 1 ? "是" : "否"}
                    t.column("操作") do |item|
                      if item.tp == 0
                        link_to "设置为班主任",url_for(:controller=>"/admin/teachers",:action=>:set_class_teacher,:teacher_id=>item.id, :squad_id => item.squad_id, :back_to_user_controller => true, :anchor => "show_teachers")
                      else
                        link_to "取消班主任",url_for(:controller=>"/admin/teachers",:action=>:cancel_class_teacher, :squad_id => item.squad_id, :staff_id => staff.id, :back_to_user_controller => true, :anchor => "show_teachers")
                      end
                    end
                  end
                end
              end
            else
              ul do
                li do
                  link_to "添加教职工信息",:controller=>"/admin/staffs",:kindergarten_id=>user.kindergarten_id,:action=>:new,:id=>nil,:user_id=>user.id
                end
              end
            end
          end
        end

      end
    end
  end


end
