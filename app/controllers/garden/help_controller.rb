#encoding:utf-8
#帮助
class Garden::HelpController < Garden::BaseController
  def index
    @help_categories = []
    tp = {:tp=>:student}
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
    tp = {:tp=>:student}
    if (tp[:tp]==:student && help_category.tp_id!=0) || (tp[:tp]==:teachers && help_category.tp_id==2)
      flash[:notice]="没有权限"
    else
      @help_movie=help_category.help_movie
    end
    render :partial =>"show_video"
  end
end
