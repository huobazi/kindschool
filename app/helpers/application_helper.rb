# encoding: utf-8
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


  def destroy_topic_entry?(topic_entry)
    if current_user.tp == 2
      true
    elsif topic_entry.creater_id == current_user.id
      true
    else
      false
    end
  end

  def growth_record_controller
    if controller_name == "growth_records"
      destroy_multiple_my_school_growth_records_path
    else
      destroy_multiple_my_school_garden_growth_records_path
    end
  end

end
