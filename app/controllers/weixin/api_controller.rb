#encoding:utf-8
class Weixin::ApiController < Weixin::BaseController
  protect_from_forgery :except=>:index
  include AuthenticatedSystem
  before_filter :token_validate , :if=>proc {|c| (@required_type != :www && @required_type != "") && @kind.weixin_status == 0 }
  #交互接口
  def index
    if @required_type == :www || @required_type == ""
      load_platform
    else
      load_school
    end
  end



  protected
  
  #学校api接口
  def load_school
    xml_data = params[:xml]
    #关注
    if xml_data[:Event] == "subscribe"
      x_data = mas_data({:ToUserName=>xml_data[:FromUserName],
          :FromUserName=>xml_data[:ToUserName],
          :CreateTime=>Time.now.to_i,
          :MsgType=>"text",
          :Content=>"欢迎关注#{@kind.name}\n\r #{get_menu} ",
          :FuncFlag=>0
        })
      puts  "==x_data===========#{x_data.inspect}====="
    else
      xml_data[:Content]
      #图片形式
      x_data = mas_data({:ToUserName=>xml_data[:FromUserName],
          :FromUserName=>xml_data[:ToUserName],
          :CreateTime=>Time.now.to_i,
          :MsgType=>"news",
          :Content=>"回复数字进行操作\n\r ",
          :ArticleCount=>2,
          :Articles=>[{:Title=>"标题",:Description=>"描述",:PicUrl=>"图片地址",:Url=>"跳转地址"}],
          :FuncFlag=>0
        })
    end
    render :text=>x_data
  end

  #平台接口
  def load_platform
    xml_data = params[:xml]
    render :text=>"平台"
  end

  private


  def token_validate
    render :text=>params[:echostr]
    return
  end

  def get_menu
    if logged_in?
      "1、进行账号绑定\n\r 2、查看幼儿园介绍"
    else
      "1、查看通知消息\n\r 2、幼儿园介绍\n\r 3、班级活动\n\r 4、每周菜谱\n\r 5、照片集锦\n\r 6、宝宝成长\n\r 6、信息论坛"
    end
  end

  def mas_data(option = {})
    msg_arr = []
    option.each do |k,v|
      if k == "FuncFlag".to_sym
        msg_arr << "<#{k}>#{v}</#{k}>"
      else
        msg_arr << "<#{k}><![CDATA[#{v}]]></#{k}>"
      end
    end
    return "<xml>" + msg_arr.join("") + "</xml>"
  end
end
