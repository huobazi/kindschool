#encoding:utf-8
#微信查看新闻
class Weixin::NewsController < Weixin::ManageController
  def index
   @news = News.where("kindergarten_id = ? and approve_status = 0 or create_id=?",@kind.id,current_user.id).page(params[:page] || 1).per(10)
  end
  def show
  	@new = @kind.news.find(params[:id])
    ActiveRecord::Base.transaction do
      @new.show_count =@new.show_count.to_i + 1
      @new.save
    end
  end
end
