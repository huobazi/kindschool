#encoding:utf-8
ActiveAdmin.register Kindergarten do
  menu :parent => "幼儿园管理", :priority => 1

  member_action :loading, :method => :get do
    @kindergarten = Kindergarten.find(params[:id])
    @kindergarten.loading!
    flash[:notice] ="初始化完成."
    redirect_to(:controller=>"/admin/kindergartens", :action=>:show,:id=>params[:id])
  end

  member_action :pay_sms, :method => :get, :title => "充值短信" do
    @kindergarten = Kindergarten.find_by_id(params[:id])
  end

  member_action :pay_sms_count, :method => :post do
    if @kindergarten = Kindergarten.find_by_id(params[:id])
      if params[:pay_count].blank?
        flash[:error] = "短信条数不能为空"
        redirect_to :action => :pay_sms, :controller => "/admin/kindergartens",:id=>params[:id]
      else
        SmsLog.pay_count(@kindergarten.id,params[:pay_count].to_i,current_admin_user.id)
        flash[:success] = "操作成功"
        redirect_to :action => :show, :controller => "/admin/kindergartens", :id => @kindergarten.id
      end
    else
      flash[:error] = "幼儿园不存在"
      redirect_to :action => :index, :controller => "/admin/kindergartens"
    end
  end


  member_action :default_role, :method => :get do
    @kindergarten = Kindergarten.find(params[:id])
    @kindergarten.default_role!
    flash[:notice] = "还原所有角色默认权限成功"
    redirect_to(:controller=>"/admin/kindergartens", :action=>:show,:id=>params[:id])
  end

  action_item :only => :show do
    if can?(:loading, resource)
      if kindergarten.init_status
        link_to('初始化数据', loading_admin_kindergarten_path(kindergarten))
      end
    end
  end

  action_item :only => :show do
    if can?(:default_role, resource)
      link_to('还原所有角色默认权限', default_role_admin_kindergarten_path(kindergarten))
    end
  end

  action_item :only => :show do
    if can?(:pay_sms, resource)
      link_to('充值短信', pay_sms_admin_kindergarten_path(kindergarten))
    end
  end

  index do
    column  :number do |obj|
      auto_link obj,obj.number
    end
    column :name do |obj|
      auto_link obj,obj.name
    end
    column :status do |obj|
      Kindergarten::STATUS_DATA["#{obj.status}"]
    end
    column :template
    column :weixin_status_label
    # column :weixin_code
    column :asset_img do |obj|
      if obj.asset_img.blank?
        raw "图片不存在"
      else
        raw "<img src='#{obj.asset_img.public_filename(:tiny)}'  onerror='this.src='/assets/no_img.png'"
      end
    end
    # column :asset_logo do |obj|
    #   if obj.asset_logo.blank?
    #     raw "二维码不存在"
    #   else
    #     raw "<img src='#{obj.asset_logo.public_filename(:tiny)}'  onerror='this.src='/assets/no_img.png'"
    #   end
    # end

    column :admin do |obj|
      if obj.admin.blank?
        link_to "添加管理员",:action=>:new,:controller=>"/admin/users",:tp=>"admin",:kindergarten_id=>obj.id
      else
        link_to "#{obj.admin.login}|#{obj.admin.name}",:action=>:show,:controller=>"/admin/users",:id=>obj.admin.id
      end
    end
    default_actions
  end

  filter :number
  filter :name
  filter :weixin_status, :as => :select, :collection => Kindergarten::WEIXIN_STATUS_DATA.invert
  filter :weixin_code

  form do |f|
    f.inputs "幼儿园信息" do
      f.input :number
      f.input :name
      f.input :status,:as=>:select,:collection=>Kindergarten::STATUS_DATA.invert
      f.input :template#, :selected => f.object.default_template
      f.input :weixin_status,:as=>:select,:collection=>Kindergarten::WEIXIN_STATUS_DATA.invert
      f.input :weixin_code
      f.input :weixin_token
      f.input :telephone
      f.input :show_cookbook,:as=>:select,:collection=>Kindergarten::SHOW_COOKBOOK_DATA.invert
      f.input :latlng
      f.input :address
      f.input :aliases_url
      f.input :sms_count
      f.input :sms_user_count
      f.input :begin_allsms
      f.input :open_allsms
      f.input :enable_credit
      f.input :hint_tp
      #      f.input :allsms_count
      f.input :login_note
      f.input :note
      f.input :init_status
    end

    f.inputs "选择幼儿园所属地区" do
      f.input :kind_zone_id
    end

    f.inputs "LOGO", :for => [:asset_img, f.object.asset_img || AssetImg.new] do |img|
      img.input :uploaded_data,:as=>:file,:name => "asset_img"
    end
    f.inputs "二维码", :for => [:asset_logo, f.object.asset_logo || AssetLogo.new] do |img|
      img.input :uploaded_data,:as=>:file,:name => "asset_logo"
    end
    f.actions
  end

  show do |kind|
    attributes_table do
      row :id
      row :number
      row :name
      row :status do |obj|
        Kindergarten::STATUS_DATA["#{obj.status}"]
      end
      row :template
      row :weixin_status_label
      row :weixin_code
      row :weixin_token
      row :show_cookbook do |obj|
        Kindergarten::SHOW_COOKBOOK_DATA["#{obj.show_cookbook}"]
      end
      row :telephone
      row :latlng
      row :address
      row :aliases_url
      row :sms_count
      row :balance_count
      row :sms_user_count
      row :begin_allsms_label
      row :open_allsms_label
      row :hint_tp_label
      #      row :allsms_count
      row :login_note
      row :note
      row :asset_img do |obj|
        if obj.asset_img.blank?
          raw "图片不存在"
        else
          raw "<img src='#{obj.asset_img.public_filename(:tiny)}'  onerror='this.src='/assets/no_img.png'"
        end
      end
      row :asset_logo do |obj|
        if obj.asset_logo.blank?
          raw "二维码不存在"
        else
          raw "<img src='#{obj.asset_logo.public_filename(:tiny)}'  onerror='this.src='/assets/no_img.png'"
        end
      end
      row :created_at
      row :updated_at

      #这个地方加一个用户绑定统计
      div do
        br
        panel "幼儿园统计" do
          render :partial => "/admin/kindergartens/kindergartens_sas",:locals => { :kind => kind.id }
        end
      end

      div do
        br
        panel "班级信息" do
          unless kind.squads.blank?
            table_for(kind.squads) do |t|
              t.column("班级") {|item| auto_link item }
              t.column("年级") {|item| item.grade ? (auto_link item.grade) : "未选择年级" }
              t.column("班级人数") {|item| link_to "#{item.student_infos.count}人",:controller=>"/admin/student_infos",:action=>:index,"q[kindergarten_id_eq]"=>kind.id,"q[squad_name_contains]"=>item.name }
              t.column("操作") {|item| link_to "添加学员",:controller=>"/admin/student_infos",:kindergarten_id=>kind.id,:action=>:new,:id=>nil,:squad_id=>item.id }
              tr :class => "odd" do
                td ""
                td "总人数:", :style => "text-align: right;"
                td "#{kind.student_infos.count}人"
                td ""
              end
            end
          end
          ul do
            li do
              span :class => "action_item" do
                link_to "添加班级",:controller=>"/admin/squads",:kindergarten_id=>kind.id,:action=>:new,:id=>nil
              end
              span :class => "action_item" do
                link_to "查看班级列表",:controller=>"/admin/squads",:action=>:index,:id=>nil,"q[kindergarten_id_eq]"=>kind.id
              end
            end
          end
        end
      end

      div do
        br
        panel "教职工信息" do
          unless kind.staff_users.blank?
            table_for(kind.staff_users) do |t|
              t.column("名称") {|item| auto_link item}
              t.column("性别") {|item| item.gender == "G" ? "男" : "女"}
              t.column("入职时间") {|item| item.staff ? item.staff.come_in_at : ""}
              t.column("教育背景") {|item| item.staff ? item.staff.education : ""}
              t.column("操作") {|item|
                if item.staff
                  link_to "分配班级",:controller=>"/admin/teachers",:action=>:allocation,:kindergarten_id=>kind.id, :staff_id=>item.staff.id
                else
                  link_to "完善教职工信息",:controller=>"/admin/staffs",:kindergarten_id=>item.kindergarten_id,:action=>:new,:id=>nil,:user_id=>item.id
                end
              }
            end
          end
          ul do
            li do
              span :class => "action_item" do
                link_to "添加教职工", :controller=>"/admin/staffs", :kindergarten_id=>kind.id, :action=>:new, :id=>nil
              end
            end
          end
        end
      end

      div do
        br
        panel "最新贴子信息" do
          unless kind.topics.blank?
            table_for(kind.topics.limit(10).order("id DESC")) do |t|
              t.column("标题") {|item| item.title}
              t.column("发贴人") {|item| item.creater.try(:name)}
              t.column("创建时间") { |item| item.created_at }
              tr :class => "odd" do
                td ""
                td "贴子总数", :style => "text-align: right;"
                td "#{kind.topics.count}"
              end
            end
          else
            "未有贴子"
          end
          ul do
            li :class => "btn-black" do
              span :class => "action_item" do
                link_to "查看贴子列表", :controller => "/admin/topics", :action => :index,"q[kindergarten_id_eq]"=>kind.id
              end
            end
          end
        end
      end


      div do
        br
        panel "菜谱信息" do
          unless kind.cook_books.blank?
            table_for(kind.cook_books.limit(10).order("id DESC")) do |t|
              t.column("开始时间") {|item| item.start_at.to_short_datetime unless item.start_at.nil?}
              t.column("结束时间") {|item| item.end_at.to_short_datetime unless item.end_at.nil?}
              #              t.column("类型") {|item| item.range_tp}
              tr :class => "odd" do
                td "菜谱总数", :style => "text-align: right;"
                td "#{kind.cook_books.count}"
              end
            end
          else
            "未创建菜谱"
          end
          ul do
            li do
              span :class => "action_item" do
                link_to "创建菜谱", :controller => "/admin/cook_books", :action => :new, :kindergarten_id => kind.id
              end
            end
          end
        end
      end

      div do
        br
        panel "精彩视频信息" do
          unless kind.wonderful_episodes.blank?
            table_for(kind.wonderful_episodes.limit(10).order("id DESC")) do |t|
              t.column("标题") {|item| item.title}
              t.column("url地址") {|item| item.url_address}
              t.column("创建人") { |item| item.creater.name if item.creater }
              t.column("可见性") { |item| item.squad_label }
              tr :class => "odd" do
                td "精彩视频总数", :style => "text-align: right;"
                td "#{kind.wonderful_episodes.count}"
              end
            end
          else
            "未创建精彩视频"
          end
          ul do
            li do
              span :class => "action_item" do
                link_to "创建精彩视频", :controller => "/admin/wonderful_episodes", :action => :new, :kindergarten_id => kind.id
              end
            end
          end
        end
      end

      div do
        br
        panel "通知信息" do
          unless kind.notices.blank?
            table_for(kind.notices.limit(10).order("id DESC")) do |t|
              t.column("标题") {|item| item.title}
              t.column("创建人") {|item| item.try(:creater).try(:name)}
              t.column("通知范围") {|item| item.send_range_label}
              tr :class => "odd" do
                td ""
                td "通知总数", :style => "text-align :right;"
                td "#{kind.notices.count}"
                td ""
              end
            end
          else
            "未创建通知"
          end
          ul do
            li do
              span :class => "action_item" do
                link_to "创建通知", :controller => "/admin/notices", :action => :new, :kindergarten_id => kind.id
              end
            end
          end
        end
      end

      div do
        br
        panel "最新消息信息" do
          unless kind.messages.blank?
            table_for(kind.messages.where("tp=1 or tp=2").limit(10).order("id DESC")) do |t|
              t.column("标题") {|item| item.title}
              t.column("发送人") {|item| item.sender.try(:name)}
              t.column("类型") {|item| item.tp_data_label}
              t.column("状态") {|item| item.status_data_label}
              t.column("发送时间") {|item| item.send_date.try(:to_long_datetime)}
              tr :class => "odd" do
                td ""
                td "消息总数", :style => "text-align :right;"
                td "#{kind.messages.count}"
                td ""
              end
            end
          else
            "未创建消息"
          end
          ul do
            #            li do
            #              link_to "创建消息", :controller => "/admin/messages", :action => :new, :kindergarten_id => kind.id
            #            end
            li do
              span :class => "action_item" do
                link_to "查看消息列表", :controller => "/admin/messages", :action => :index,"q[kindergarten_id_eq]"=>kind.id
              end
            end
          end
        end
      end
      div do
        br
        panel "最新成长记录" do
          unless kind.growth_records.blank?
            table_for(kind.growth_records.limit(10).order("id DESC")) do |t|
              t.column("创建人") {|item| item.creater.try(:name)}
              t.column("内容") {|item| truncate item.content}
              t.column("所属学员") {|item| item.student_info.try(:name)}
              t.column("类型") {|item| GrowthRecord::TP_DATA[item.tp.to_s]}
              t.column("创建时间") {|item| item.created_at.try(:to_short_datetime)}
              tr :class => "odd" do
                td ""
                td "成长记录总数", :style => "text-align :right;"
                td "#{kind.growth_records.count}"
                td ""
                td ""
              end
            end
          else
            "没有成长记录消息"
          end
          ul do
            li do
              span :class => "action_item" do
                link_to "查看成长记录列表", :controller => "/admin/growth_records", :action => :index,"q[kindergarten_id_eq]"=>kind.id
              end
            end
          end
        end
      end

      div do
        br
        panel "活动信息" do
          unless kind.activities.blank?
            table_for(kind.activities.limit(10).order("id DESC")) do |t|
              t.column("标题") {|item| item.title}
              t.column("创建人") {|item| item.creater_id}
              t.column("活动类型") {|item| item.tp == 0 ? "活动" : "兴趣讨论"}
              t.column("开始时间") {|item| item.start_at.to_short_datetime}
              t.column("结束时间") {|item| item.end_at.to_short_datetime}
              tr :class => "odd" do
                td ""
                td "活动总数", :style => "text-align :right;"
                td "#{kind.activities.count}"
                td ""
                td ""
              end
            end
          else
            "未创建活动"
          end
        end
      end

      div do
        br
        panel "页面内容信息" do
          unless kind.page_contents.blank?
            table_for(kind.page_contents) do |t|
              t.column("编号") {|item| item.number}
              t.column("名称") {|item| item.name}
              t.column("所属幼儿园") {|item| item.kindergarten_label}
              tr :class => "odd" do
                td ""
                td "页面内容总数", :style => "text-align :right;"
                td "#{kind.page_contents.count}"
              end
            end
          else
            "未创建页面内容"
          end
        end

        ul do
          li do
            span :class => "action_item" do
              link_to "创建页面内容", :controller => "/admin/page_contents", :action => :new, :kindergarten_id => kind.id
            end
          end
        end
      end

      div do
        br
        panel "论坛分类信息" do
          unless kind.topic_categories.blank?
            table_for(kind.topic_categories) do |t|
              t.column("名称") {|item| item.name}
              tr :class => "odd" do
                td "论坛分类总数#{kind.topic_categories.count}", :style => "text-align: right;"
              end
            end
          else
            "还没有论坛分类"
          end
          ul do
            li do
              span :class => "action_item" do
                link_to "创建论坛分类", :controller => "/admin/topic_categories", :action => :new, :kindergarten_id => kind.id
              end
              span :class => "action_item" do
                link_to "查看论坛分类列表", :controller => "/admin/topic_categories", :action => :index,"q[kindergarten_id_eq]"=>kind.id
              end
            end
          end
        end
      end

      div do
        br
        panel "seo关键字优化" do
          unless kind.shrink_record.blank?
            ul do
              li do
                kind.shrink_record.keywords
              end
              li do
                kind.shrink_record.description
              end
            end
            ul do
              li do
                span :class => "action_item" do
                  link_to "查看seo关键字列表", :controller => "/admin/shrink_records", :action => :index,"q[kindergarten_id_eq]"=>kind.id
                end
              end
            end
          else
            "还没有seo关键字优化"
            ul do
              li do
                span :class => "action_item" do
                  link_to "创建seo关键字优化", :controller => "/admin/shrink_records", :action => :new, :kindergarten_id => kind.id
                end
              end
              li do
                span :class => "action_item" do
                  link_to "查看seo关键字列表", :controller => "/admin/shrink_records", :action => :index,"q[kindergarten_id_eq]"=>kind.id
                end
              end
            end
          end
        end
      end

      div do
        br
        panel "功能信息" do
          unless kind.operates.blank?
            ul(:class=>"operate_ul") do
              kind.operates.each do |item|
                li do
                  item.name
                end
              end
            end
          end
        end

        ul do
          li do
            span :class => "action_item" do
              link_to "添加功能", :controller=>"/admin/option_operates", :kindergarten_id=>kind.id, :action=>:add_functional_to_kind, :id=>nil
            end
          end
        end
      end


    end
  end

  sidebar "年级", :only => :show do
    kind = Kindergarten.find(params[:id])
    unless kind.grades.blank?
      ul do
        kind.grades.order(:sequence).each do |entry|
          li do
            span :class => "action_item" do
              link_to entry.name,:controller=>"/admin/grades",:action=>:show,:id=>entry.id
            end
          end
        end
      end
      hr
    end
    ul do
      li do
        span :class => "action_item" do
          link_to "添加年级",:controller=>"/admin/grades",:kindergarten_id=>kind.id,:action=>:new,:id=>nil
        end
      end
      li do
        span :class => "action_item" do
          link_to "查看年级列表",:controller=>"/admin/grades",:action=>:index,:id=>nil,"q[kindergarten_id_eq]"=>kind.id
        end
      end
    end
  end

  sidebar "管理员信息", :only => [:show] do
    kind = Kindergarten.find(params[:id])
    ul do
      li do
        if kind.admin.blank?
          span :class => "action_item" do
            link_to "添加管理员",:action=>:new,:controller=>"/admin/users",:tp=>"admin",:kindergarten_id=>kind.id,:id=>nil
          end
        else
          span :class => "action_item" do
            link_to "#{kind.admin.login}|#{kind.admin.name}",:action=>:show,:controller=>"/admin/users",:id=>kind.admin.id
          end
        end
      end
      li do
        span :class => "action_item" do
          link_to "设置默认模版", :controller => "/admin/templates", :action => :index, :kindergarten_id => kind.id, :id=>nil
        end
      end
    end
  end

end
