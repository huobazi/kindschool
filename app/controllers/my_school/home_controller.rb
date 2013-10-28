#encoding:utf-8
class  MySchool::HomeController < MySchool::ManageController
  #登陆后首页
  def index
    @activities = @kind.activities.limit(8).order("created_at DESC")
    @recent_activities = @kind.activities.limit(2).order("created_at DESC")
  end
  def help_videos
    @help_categories = []
    tp = current_user.get_users_ranges
    HelpCategory.roots.each do |n|
        n.self_and_descendants.each_with_level do |item, level|
          item[:lvl] = level
         next if tp[:tp] == :student && item[:tp_id] != 0 
         next if tp[:tp] == :teachers && item[:tp_id] == 2
          @help_categories << item
        end
    end
  end
  def show_videos
    category_id = params[:group_id]
    help_category = HelpCategory.find(category_id.to_i) 
    tp = current_user.get_users_ranges
    if (tp[:tp]==:student && help_category.tp_id!=0) || (tp[:tp]==:teachers && help_category.tp_id==2)
      flash[:notice]="没有权限"
    else
      @help_movie=help_category.help_movie
    end
    render :partial =>"show_video"
  end

  def about
    
  end
  def contact_us

  end
end
