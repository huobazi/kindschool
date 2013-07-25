#encoding:utf-8
class  MySchool::TopicCategoriesController < MySchool::ManageController
  include_kindeditor :only => [:new, :edit]
  
  def index
    @topic_categories = @kind.topic_categories.search(params[:topic_category] || {}).page(params[:page] || 1).per(10).order("created_at DESC")
  end

  def show
    @topic_category = @kind.topic_categories.find_by_id(params[:id])
  end

  def edit
    @topic_category = @kind.topic_categories.find_by_id(params[:id])
  end

  def new
    @topic_category = TopicCategory.new
    @topic_category.kindergarten_id = @kind.id
  end

  def update
    @topic_categories = @kind.topic_categories.find_by_id(params[:id])

    if @topic_categories.update_attributes(params[:topic_category])
      flash[:success] = "修改论坛分类成功"
      redirect_to my_school_topic_categories_path(@topic_category)
    else
      flash[:error] = "修改论坛分类未能成功"
      render :edit
    end
  end

  def create
    @topic_category = TopicCategory.new(params[:topic_category])

    if @topic_category.save!
      flash[:success] = "添加论坛分类成功"
      redirect_to my_school_topic_category_path(@topic_category)
    else
      flash[:error] = "添加论坛分类未能成功"
      redirect_to my_school_topic_categories_path
    end
  end

  def destroy_multiple
    if params[:topic_category].nil?
      flash[:notice] = "必须选择论坛分类"
    else
      params[:topic_category].each do |topic_category|
        @kind.topic_categories.destroy(topic_category)
      end
    end
    respond_to do |format|
      format.html { redirect_to my_school_topic_categories_path }
      format.json { head :no_content }
    end
  end
end

