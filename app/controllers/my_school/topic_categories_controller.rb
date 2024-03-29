#encoding:utf-8
class  MySchool::TopicCategoriesController < MySchool::ManageController
  # include_kindeditor :only => [:new, :edit]

  def index
    @topic_categories = @kind.topic_categories.search(params[:topic_category] || {}).page(params[:page] || 1).per(10).order("created_at DESC")
  if request.xhr?
    @search_record = "topic_categories"
    @search_record_count = @topic_categories.total_count
    render "my_school/commons/_search_index.js.erb"
  else
    render "index"
  end
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
    params[:topic_category][:kindergarten_id] = @kind.id if params[:topic_category]
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
    @topic_category.kindergarten_id = @kind.id

    if @topic_category.save!
      flash[:success] = "添加论坛分类成功"
      redirect_to my_school_topic_category_path(@topic_category)
    else
      flash[:error] = "添加论坛分类未能成功"
      redirect_to my_school_topic_categories_path
    end
  end

  def destroy

    if @topic_category = @kind.topic_categories.find_by_id(params[:id])
    end

    if @topic_category.nil?
      flash[:error] = "请选择论坛分类"
      redirect_to :action => :index
      return
    end

    @topic_category.destroy

    respond_to do |format|
      flash[:success] = "删除论坛分类成功"
      format.html { redirect_to my_school_topic_categories_path }
      format.json { head :no_content }
    end

  end

end

