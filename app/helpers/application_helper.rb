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
