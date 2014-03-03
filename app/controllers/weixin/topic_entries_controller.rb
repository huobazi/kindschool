#encoding:utf-8
class Weixin::TopicEntriesController < Weixin::ManageController
  def create
    @topic_entry = TopicEntry.new(params[:topic_entry])

    if @topic_entry.save
      #自己回复的不能进行加积分
     if @topic.creater.id != current_user.id
       if current_user.save_user_credit("topic",1,@topic)
        #反馈意见的要给发帖人加分
        @topic.creater.save_creater_credit("topic",@topic) if @topic.creater

       end
     end
      flash[:success] = "添加回复成功"
      redirect_to weixin_topic_path(@topic_entry.topic_id, :page => @topic_entry.topic.last_page, :anchor => "topic_entry_#{@topic_entry.id}")
    else
      flash[:error] = "添加回复失败"
      redirect_to :back
    end
  end

end
