#encoding:utf-8
#新闻的发布
class MySchool::NewsController <  MySchool::ManageController
   def index
    @flag = false
    userrole = current_user.get_users_ranges
    if userrole[:tp] == :all
      @flag=true
      @news = @kind.news.page(params[:page] || 1).per(10)
    else
      @news = News.where("kindergarten_id = ? and approve_status = 0 or create_id=?",@kind.id,current_user.id).page(params[:page] || 1).per(10)
    end
   end

   def new
   	 @new = News.new()
     @new.kindergarten_id = @kind.id
   end

   def create
     @new = News.new(params[:news])
     @new.kindergarten = @kind
     @new.creater = current_user
     if @new.save!
      flash[:success] = "创建新闻成功"
      redirect_to my_school_news_path(@new)
    else
      flash[:error] = "创建新闻不成功"
      render :new
    end

   end

   def edit
    #shifoushi admin
    #else
    #creater = flash[]
   	@new = @kind.news.find(params[:id])
   end

   def update
   	@new = @kind.news.find(params[:id])
    respond_to do |format|
      if @new.update_attributes(params[:news])
        format.html { redirect_to my_school_news_path(@new), notice: '新闻更新成功.' }
      else
        format.html { render action: "edit" }
      end
    end
   end

   def show
   	@new = @kind.news.find(params[:id])
   end

   def destroy
    unless params[:news].blank? 
  	  @news = @kind.news.where(:id=>params[:news])
    else
      @news = @kind.news.where(:id=>params[:id]) 
    end
     @news.each do |news|
         news.destroy
     end
    flash[:notice] = '删除成功.'
    respond_to do |format|
      format.html { redirect_to my_school_news_index_path }
      format.json { head :no_content }
    end
   end
end
