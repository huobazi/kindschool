# encoding: utf-8
include UploadifyRailsHelper
module ApplicationHelper
  def sys_admin_menus(t=nil)
    current_menus = MENUS
    menus = current_user.authed_menus(t)
    miss = true
    menus.each do |m|
      current_menu = m[:children] #&& m[:children].select{|c| c[:url].to_s.size>1 && request.path.start_with?(c[:url].to_s)}
      if mmm=current_menus[m[:number]]
        current_menu.each do |cu|
          if mmmm=mmm[cu[:number]]#!mmm[cu[:number]].blank?#.include?(params[:action])
            if control=mmmm[params[:controller]]
              if control.include?(params[:action])
                cu[:current] = true
                m[:current] = true
                miss = false
                # break
              end
            end
          end
        end
      end
    end
    menus
  end
  
  def include_jquery_ui_tag(*args)
    #jqs=[javascript_include_tag('jquery-ui.min') , stylesheet_link_tag('jqueryui/jqueryui')]
    #args.each do |arg|
    #  jqs << javascript_include_tag("jquery-ui-#{arg}")
    #end
    #jqs.join("\n").html_safe
    jqs='<link href="/css/jqueryui/jqueryui.css" media="screen" rel="stylesheet" type="text/css" /><script src="/js/jquery-ui.min.js" type="text/javascript"></script>'
    args.each do |arg|
      jqs << "<script src=\"/js/jquery-ui-#{arg}.js\" type=\"text/javascript\"></script>"
    end
    jqs.html_safe
  end

  # 用于在页面中引入jquery plugin Treeview组件
  def include_jquery_treeview_tag
    #[javascript_include_tag('jquery.treeview') , stylesheet_link_tag('treeview/treeview')].join("\n").html_safe
    '<link href="/css/treeview/treeview.css" media="screen" rel="stylesheet" type="text/css" /><script src="/js/jquery.treeview.js" type="text/javascript"></script>'.html_safe
  end

  # 用于在页面中引入jquery treeTable组件
  def include_jquery_treetable_tag
    '<link href="/css/treetable/jquery.treetable.css" media="screen" rel="stylesheet" type="text/css" /><script src="/js/jquery.treetable.js" type="text/javascript"></script>'.html_safe
  end

  # jquery jstree插件：在需要使用jquery jstree插件的页面调用
  # jstree源码：https://github.com/vakata/jstree
  def include_jquery_jstree_tag
    '<script src="/js/jquery.jstree.min.js" type="text/javascript"></script>'.html_safe
  end

  # 用于树形显示，nested_set结构的model用treeview显示
  # 此方法适用于数据量不大的场景
  # 参数1 为节点对象集合，已经按照树形从上到下顺序排列，且层级关系准确的对象集合
  # 参数2 选项参数，可用的选项有： {:current_node=>当前被点击选中的node, :link=>}
  def nested_set_to_treeview(node_set, options={})
    options ||= {}
    html=''
    temp_level = 0
    (node_set||[]).each_with_index do |item, i|
      levels = item[:lvl] || item.level
        if temp_level >levels
            (temp_level -levels).times do |i|
                 html << "</ul></li>"
                end
            temp_level = levels
        end
        if temp_level < levels
           html << "<ul>" 
           temp_level +=1
        end
      html << "<li class='#{'focus' if options[:current_node]==item}'><span class='#{item.leaf? ? 'file':'folder'}' nodeid=#{item.id}>#{item.name}</span>"
      if item.leaf?
        html << "</li>"
      end
    end
    temp_level.times do |i|
      html << "</ul></li>"
    end if temp_level > 0
    html.html_safe
  end
  #常用功能菜单
  def useful_features_menu
    menus = current_user.smarty_menu
  end

  def can_destroy_comment?(comment)
    if current_user.get_users_ranges[:tp] == :all
      true
    elsif current_user.id == comment.user.id
      true
    else
      false
    end
  end

  def can_edit_comment?(comment)
    if current_user.id == comment.user.id
      true
    else
      false
    end
  end


  def store_search_location
    session[:return_to] = request.query_parameters
  end

  def growth_record_controller
    if controller_name == "growth_records"
      destroy_multiple_my_school_growth_records_path
    else
      destroy_multiple_my_school_garden_growth_records_path
    end
  end

  def up_to_default_grade(squad_id)
    squad = Squad.find_by_id(squad_id)

    if grade = Grade.find_by_id(squad.grade_id)
      # 选择年级序号大于该班级所属年级的所有班级的第一个,也就是升到的年级
      default_grade = Grade.where("sequence > ?", grade.sequence).first
      return default_grade
    else
      "没年级的班不做升学"
    end
  end
#  def get_required_form_data
#    required_form_data
#  end
#
#private
#  def required_form_data
#    @session_key ||= ::Rails.application.config.session_options[:key]
#    @forgery_token = request_forgery_protection_token
#    {
#      @session_key   => cookies[@session_key],
#      @forgery_token => form_authenticity_token
#    }
#  end
end
