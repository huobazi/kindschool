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
            puts "2222222222222222222"
            puts mmmm.inspect
            if control=mmmm[params[:controller]]
              puts "11111111111111111111111"
              puts control.inspect
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
    # if miss && menus[0] && menus[0][:children] && menus[0][:children][0]
    #       menus[0][:current] = true
    # end
    menus
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

end
