#encoding:utf-8
class Weixin::TopicsController < Weixin::ManageController
  def index
    @topics = @kind.topics.page(params[:page] || 1).per(10)
  end

  def show
    @topic = @kind.topics.find(params[:id])
  end
end
