#encoding:utf-8
class MySchool::BaseController < ApplicationController
  before_filter :my_school, :except => :no_kindergarten
  layout proc{ |controller| get_layout }


  
  private
  def my_school
    if @kind = Kindergarten.find_by_number(@subdomain)   
    else
      redirect_to :action => :no_kindergarten,:controller=>"/my_school/main"
    end
  end

  #设置模板
  def get_layout
    session[:main_layout] ||= "#{load_layout}_main"
  end
  def load_layout
    if @kind && @kind.template
      @kind.template.number
    else
      if template = Template.find_by_is_default(1)
        template.number
      else
        raise "模板信息缺失，请联系管理员"
      end
    end
  end
end
