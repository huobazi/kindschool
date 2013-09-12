#encoding:utf-8
ActiveAdmin.register StudentInfo do
  menu :parent => "用户管理", :priority => 5


  controller do
    def new
      @student_info = StudentInfo.new()
      if @kindergarten = Kindergarten.find_by_id(params[:kindergarten_id])
        @student_info.kindergarten = @kindergarten
        if params[:user_id]
          if (user = User.find_by_id_and_kindergarten_id(params[:user_id],params[:kindergarten_id]))
            if user.tp != 0
              flash[:notice] = "该账号非学员类型."
              redirect_to :action => :index,:controller=>"/admin/kindergartens"
              return
            end
            @student_info.user_id = user.id
          else
            flash[:notice] = "指定的用户有误."
            redirect_to :action => :index,:controller=>"/admin/kindergartens"
            return
          end
        else
          @student_info.user = User.new(:kindergarten_id=>@kindergarten.id,:tp=>0)
        end

        if params[:squad_id] && (squad = Squad.find_by_id_and_kindergarten_id(params[:squad_id],@kindergarten.id))
          @student_info.squad = squad
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
    column :user
    column :kindergarten
    column "年级" do |obj|
      obj.squad && obj.squad.grade ? (auto_link obj.squad.grade) : "无年级"
    end
    column :squad
    column :guardian
    column :come_in_at
    column :created_at
    column :updated_at
    default_actions
  end

  filter :user_name,:as=>:string,:label=>"学生名字"
  filter :squad_name,:as=>:string,:label=>"班级名称"
  #  filter :kindergarten_name,:as=>:string,:label=>"幼儿园名字"
  filter :kindergarten

  form do |f|
    f.inputs "账号信息", :for => [:user, f.object.user || User.new] do |user|
        user.input :kindergarten_id,:as=>:hidden
        if (action_name == "new" || action_name == "create") && user.object.id.blank?
          user.input :login, :required => true
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
    f.inputs "学员信息" do
      f.input :kindergarten_label, :as => :string, :input_html => { :disabled => true }
      f.input :squad, :required => true
      f.input :birthday, :as => :just_datetime_picker
      f.input :come_in_at, :as => :just_datetime_picker
      f.input :card_category, :as => :select,:collection=>StudentInfo::CARD_CATEGORY_DATA.invert
      f.input :card_code
      f.input :guardian
      f.input :guardian_card_category, :as => :select,:collection=>StudentInfo::CARD_CATEGORY_DATA.invert
      f.input :guardian_card_code
      f.input :nationality
      f.input :nation
      f.input :overseas_chinese,:as=>:select,:collection=>StudentInfo::OVERSEAS_CHINESE_DATA.invert
      f.input :household,:as=>:select,:collection=>StudentInfo::HOUSEHOLD_DATA.invert
      f.input :birthplace
      f.input :native
      f.input :domicile_place
      f.input :family_address
      f.input :lodging
      f.input :only_child
      f.input :orphan
      f.input :leftover_children
      f.input :employofficialt
      f.input :insured
      f.input :subsidize
      f.input :deformity
      f.input :deformity_category
      f.input :housing,:as=>:select,:collection=>StudentInfo::HOUSING_DATA.invert
      f.input :live_family,:as=>:select,:collection=>StudentInfo::LIVE_FAMILY_DATA.invert
      f.input :brothers
      f.input :children_number
      f.input :head_url
      f.input :kindergarten_id,:as=>:hidden
    end
    f.inputs "家庭信息" do
      f.input :family_ties
      f.input :family_name
      f.input :politics_status
      f.input :family_birthday, :as => :just_datetime_picker
      f.input :profession
      f.input :duties
      f.input :working
      f.input :family_register
      f.input :family_phone
      f.input :family_email
      f.input :living_time
      f.input :family_marital
      f.input :education
      f.input :safe_box
      f.input :user_id,:as=>:hidden
    end
    f.actions
  end

  show do |student_info|
    user = student_info.user
    div :class=>"attributes_table grade" do
      panel "账号信息" do
        table_for([]) do |t|
          tr :class => "row" do
            th "账号"
            td user.login
          end
          tr :class => "row" do
            th "姓名"
            td user.name
          end
          tr :class => "row" do
            th "手机号"
            td user.phone
          end
          tr :class => "row" do
            th "性别"
            td user.gender_label
          end
          tr :class => "row" do
            th "类型"
            td user.tp_label
          end
          tr :class => "row" do
            th "所属幼儿园"
            td user.kindergarten_label
          end
        end
      end
    end

    panel "学员信息" do
      table_for([]) do
        tr :class => "odd" do
          td "年级:",:class=>"tdColumn"
          td student_info.squad.grade_label
          td "班级:",:class=>"tdColumn"
          td student_info.squad.name
        end
        tr do
          td "出生日期:",:class=>"tdColumn"
          td (student_info.birthday ? student_info.birthday.to_short_datetime : "")
          td "入园时间:",:class=>"tdColumn"
          td (student_info.come_in_at ? student_info.come_in_at.to_short_datetime : "")
        end
        tr :class => "odd" do
          td "证件类别:",:class=>"tdColumn"
          td student_info.card_category_label
          td "证件号:",:class=>"tdColumn"
          td student_info.card_code
        end
        tr do
          td "监护人名字:",:class=>"tdColumn"
          td student_info.guardian
          td "监护人证件类别:",:class=>"tdColumn"
          td student_info.guardian_card_category_label
        end
        tr :class => "odd" do
          td "国籍:",:class=>"tdColumn"
          td student_info.nationality
          td "民族:",:class=>"tdColumn"
          td student_info.nation
        end
        tr do
          td "港澳台侨:",:class=>"tdColumn"
          td student_info.overseas_chinese_label
          td "户口性质:",:class=>"tdColumn"
          td student_info.household_label
        end
        tr :class => "odd" do
          td "出生地:",:class=>"tdColumn"
          td student_info.birthplace
          td "籍贯:",:class=>"tdColumn"
          td student_info.native
        end
        tr do
          td "户口所在地:",:class=>"tdColumn"
          td student_info.domicile_place
          td "家庭地址:",:class=>"tdColumn"
          td student_info.family_address
        end
        tr :class => "odd" do
          td "是否寄宿生:",:class=>"tdColumn"
          td (student_info.lodging ? "是" : "否")
          td "是否独生子女:",:class=>"tdColumn"
          td (student_info.only_child ? "是" : "否")
        end
        tr do
          td "是否孤儿:",:class=>"tdColumn"
          td (student_info.orphan ? "是" : "否")
          td "是否留守儿童:",:class=>"tdColumn"
          td (student_info.leftover_children ? "是" : "否")
        end
        tr :class => "odd" do
          td "是否进城务工人员子女:",:class=>"tdColumn"
          td (student_info.employofficialt ? "是" : "否")
          td "是否低保:",:class=>"tdColumn"
          td (student_info.insured ? "是" : "否")
        end
        tr do
          td "是否接受资助:",:class=>"tdColumn"
          td (student_info.subsidize ? "是" : "否")
          td "是否残疾儿童:",:class=>"tdColumn"
          td (student_info.deformity ? "是" : "否")
        end
        tr :class => "odd" do
          td "残疾儿童类型:",:class=>"tdColumn"
          td student_info.deformity_category
          td "住房性质:",:class=>"tdColumn"
          td student_info.housing_label
        end
        tr do
          td "家中兄妹数:",:class=>"tdColumn"
          td student_info.brothers
          td "本人第几胎:",:class=>"tdColumn"
          td student_info.children_number
        end
      end
    end

    div :class=>"attributes_table grade" do
      panel "家庭信息" do
        table_for([]) do
          tr :class => "odd" do
            td "关系:",:class=>"tdColumn"
            td student_info.family_ties
            td "姓名:",:class=>"tdColumn"
            td student_info.family_name
          end
          tr do
            td "政治面貌:",:class=>"tdColumn"
            td student_info.politics_status
            td "出生日期:",:class=>"tdColumn"
            td (student_info.family_birthday ? student_info.family_birthday.to_short_datetime : "")
          end
          tr :class => "odd" do
            td "职业:",:class=>"tdColumn"
            td student_info.profession
            td "职务:",:class=>"tdColumn"
            td student_info.duties
          end
          tr do
            td "工作单位:",:class=>"tdColumn"
            td student_info.working
            td "户籍类型:",:class=>"tdColumn"
            td student_info.family_register
          end
          tr :class => "odd" do
            td "移动电话:",:class=>"tdColumn"
            td student_info.family_phone
            td "电子邮箱:",:class=>"tdColumn"
            td student_info.family_email
          end
          tr do
            td "父母在深连续居住时间:",:class=>"tdColumn"
            td student_info.living_time
            td "婚姻状况:",:class=>"tdColumn"
            td student_info.family_marital
          end
          tr :class => "odd" do
            td "学历:",:class=>"tdColumn"
            td student_info.education
            td "社保电脑号:",:class=>"tdColumn"
            td student_info.safe_box
          end
        end
      end
    end
  end
end
