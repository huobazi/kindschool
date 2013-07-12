#encoding:utf-8
class Weixin::ApiController < Weixin::BaseController
  include AuthenticatedSystem
  before_filter :token_validate , :if=>proc {|c| (@required_type != :www && @required_type != "") && @kind.weixin_status == 0 }
  #交互接口
  def index
    if @required_type == :www || @required_type == ""
    else
      load_school
    end
    render :text=>"demo"
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
          :Content=>"欢迎关注#{@kind.name}\r#{get_menu}\r ",
          :FuncFlag=>0
        })
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
  end

  private


  def token_validate
    render :text=>params[:echostr]
    return
  end

  def get_menu
    if logged_in?
      '1、进行账号绑定\r2、查看幼儿园介绍'
    else
      '1、查看通知消息\r2、幼儿园介绍\r3、班级活动\r4、每周菜谱\r5、照片集锦\r6、宝宝成长\r6、信息论坛'
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
