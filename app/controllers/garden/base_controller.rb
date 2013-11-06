#encoding:utf-8
class Garden::BaseController < ApplicationController
  layout "garden"
  before_filter :menu_info
  private
  def menu_info
    @menu = "home"
    data = GARDEN_MENU || []
    data.each do |menu,value|
      if arr = value[controller_path.to_s]
        if arr.include?(action_name.to_s)
          @menu = menu
          break
        end
      end
    end
  end
end
