#encoding:utf-8
class Weixin::TopicsController < Weixin::ManageController
  def index
    @send_date = [["全部时间",""],["最近3天","1"],["最近7天","2"]]
    if send_date = params[:send_date]
      if send_date == "1"
        start_time = Date.today - 3.day
        params[:messages][:send_date_greater_than] = start_time
      elsif send_date == "2"
        start_time = Date.today - 7.day
        params[:messages][:send_date_greater_than] = start_time
      end
    end
    params[:messages] = {} if params[:messages].blank?
    params[:messages][:message_entries_receiver_id_equals] = current_user.id
    @messages = Message.search(params[:messages] || {}).where("messages.kindergarten_id=:kind_id AND messages.status = :status", {:kind_id=>@kind.id,:status=>1}).page(params[:page] || 1).per(10).order("messages.send_date DESC")
    unless params[:category_id].blank?
      @topics = @kind.topics.where(:topic_category_id => params[:category_id].to_i).page(params[:page] || 1).per(10)
    else
      @topics = @kind.topics.page(params[:page] || 1).per(10)
    end
  end

  def show
    @topic = @kind.topics.find(params[:id])
    @replies = @topic.topic_entries

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
