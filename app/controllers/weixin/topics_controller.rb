#encoding:utf-8
class Weixin::TopicsController < Weixin::ManageController
  def index
    unless params[:category_id].blank?
      @topics = @kind.topics.where(:topic_category_id => params[:category_id].to_i).page(params[:page] || 1).per(10)
    else
      @topics = @kind.topics.page(params[:page] || 1).per(10)
    end
  end

  def show
    @topic = @kind.topics.find(params[:id])
    @replies = @topic.topic_entries.page(params[:page] || 1).per(10)

    @topic_entry = TopicEntry.new
    @topic_entry.topic_id = @topic.id
    @topic_entry.creater_id = current_user.id
  end

  def new
    @topic = Topic.new
    @topic.kindergarten_id = @kind.id
    @topic.creater_id = current_user.id
  end

  def create
    @topic = Topic.new(params[:topic])

    if @topic.save!
      flash[:success] = "贴子创建成功"
      redirect_to weixin_topic_path(@topic)
    else
      flash[:error] = "贴子创建失败"
      render :new
    end
  end

  def edit
    @topic = @kind.topics.find_by_id(params[:id])
  end

  def update
    @topic = @kind.topics.find_by_id(params[:id])

    if @topic.update_attributes(params[:topic])
      flash[:success] = "更新贴子成功"
      redirect_to weixin_topic_path(@topic)
    else
      flash[:error] = "更新贴子失败"
      render :edit
    end
  end
end
