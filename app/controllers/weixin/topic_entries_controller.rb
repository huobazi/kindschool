#encoding:utf-8
class Weixin::TopicEntriesController < Weixin::ManageController
  def create
    @topic_entry = TopicEntry.new(params[:topic_entry])

    if @topic_entry.save
      flash[:success] = "添加回复成功"
      redirect_to weixin_topic_path(@topic_entry.topic_id, :page => @topic_entry.topic.last_page, :anchor => "topic_entry_#{@topic_entry.id}")
    else
      flash[:error] = "添加回复失败"
      redirect_to :back
    end
  end

end
