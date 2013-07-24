#encoding:utf-8
class  MySchool::HomeController < MySchool::ManageController
  #登陆后首页
  def index
    @activities = @kind.activities.limit(8).order("created_at DESC")
    @recent_activities = @kind.activities.limit(2).order("created_at DESC")
  end

  def about
    
  end
  def contact_us

  end
end
