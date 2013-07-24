#encoding:utf-8
class Weixin::ApiController < Weixin::BaseController
  protect_from_forgery :except=>:index
  #  include AuthenticatedSystem
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
    else
      if logged_in?
        #查看消息
        if xml_data[:Content] == "1"
          x_data =mas_data({:ToUserName=>xml_data[:FromUserName],
              :FromUserName=>xml_data[:ToUserName],
              :CreateTime=>Time.now.to_i,
              :MsgType=>"text",
              :Content=>"#{current_user.name}您好!\n\r #{get_read_new_message}",
              :FuncFlag=>0
            })
        elsif xml_data[:Content] == "2"
          x_data = mas_data({:ToUserName=>xml_data[:FromUserName],
              :FromUserName=>xml_data[:ToUserName],
              :CreateTime=>Time.now.to_i,
              :MsgType=>"news",
              :Content=>"#{@kind.name}",
              :ArticleCount=>1,
              :Articles=>[{:Title=>"幼儿园介绍",:Description=>"#{@kind.note}",:PicUrl=>"http://#{request.host_with_port}#{@kind.asset_img ? @kind.asset_img.public_filename(:middle) : '/t/colorful/logo.png'}",:Url=>"http://#{request.host_with_port}/weixin/about?#{get_validate_string}"}],
              :FuncFlag=>0
            })
        else
          x_data = mas_data({:ToUserName=>xml_data[:FromUserName],
              :FromUserName=>xml_data[:ToUserName],
              :CreateTime=>Time.now.to_i,
              :MsgType=>"text",
              :Content=>"欢迎关注#{@kind.name}\n\r #{get_menu} ",
              :FuncFlag=>0
            })
        end
      else
        if xml_data[:Content] == "1"
          #绑定
          x_data = mas_data({:ToUserName=>xml_data[:FromUserName],
              :FromUserName=>xml_data[:ToUserName],
              :CreateTime=>Time.now.to_i,
              :MsgType=>"text",
              :Content=>"欢迎关注#{@kind.name}\n\r <a href=\"http://#{request.host_with_port}/weixin/main/bind_user?#{get_validate_string}code=#{xml_data[:FromUserName]}\"> 点击绑定</a>",
              :FuncFlag=>0
            })
        elsif xml_data[:Content] == "2"
          #幼儿园介绍
          x_data = mas_data({:ToUserName=>xml_data[:FromUserName],
              :FromUserName=>xml_data[:ToUserName],
              :CreateTime=>Time.now.to_i,
              :MsgType=>"text",
              :Content=>"#{@kind.name}\n\r #{@kind.note}",
              :FuncFlag=>0
            })
        end
      end
      #      xml_data[:Content]
      #      #图片形式
      #      x_data = mas_data({:ToUserName=>xml_data[:FromUserName],
      #          :FromUserName=>xml_data[:ToUserName],
      #          :CreateTime=>Time.now.to_i,
      #          :MsgType=>"news",
      #          :Content=>"欢迎关注#{@kind.name}\n\r #{get_menu} ",
      #          :ArticleCount=>2,
      #          :Articles=>[{:Title=>"标题",:Description=>"描述",:PicUrl=>"图片地址",:Url=>"跳转地址"}],
      #          :FuncFlag=>0
      #        })
    end
    Rails.logger.info("========x_data===+#{x_data.inspect}")
    render :text=>x_data
  end

  #原样返回链接验证
  def get_validate_string
    signature = ""
    arr = [:nonce,:timestamp,:signature]
    arr.each do |key|
      signature += "#{key}=#{params[key]}&"
    end
    if params[:xml] && (code = params[:xml][:FromUserName])
      signature += "xml[FromUserName]=#{code}&"
    end
    return signature
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
      "1、查看消息\n\r 2、幼儿园介绍\n\r 3、班级活动\n\r 4、每周菜谱\n\r 5、照片集锦\n\r 6、宝宝成长\n\r 7、信息论坛"
    else
      "1、进行账号绑定\n\r 2、幼儿园介绍"
    end
  end

  def get_read_new_message
    count = current_user.get_read_new_count
    if count > 0
      return "您有#{count}条未读消息\n\r <a href=\"http://#{request.host_with_port}/weixin/messages?#{get_validate_string}\"> 点击查看</a>"
    else
      return "您没有未读消息\n\r <a href=\"http://#{request.host_with_port}/weixin/messages?#{get_validate_string}\"> 查看历史消息</a>"
    end
  end

  def mas_data(option = {})
    msg_arr = []
    option.each do |k,v|
      if k == "FuncFlag".to_sym
        msg_arr << "<#{k}>#{v}</#{k}>"
      elsif k == "Articles".to_sym
        msg_arr << "<ArticleCount>#{v.count}</ArticleCount>"
        msg_arr << "<Articles>"
        v.each do |article|
          msg_arr << "<item>"
          msg_arr << "<Title><![CDATA[#{article[:Title]}]]></Title><Description><![CDATA[#{article[:Description]}]]></Description><PicUrl><![CDATA[#{article[:PicUrl]}]]></PicUrl><Url><![CDATA[#{article[:Url]}]]></Url>"
          msg_arr << "</item>"
        end
        msg_arr << "</Articles>"
      else
        msg_arr << "<#{k}><![CDATA[#{v}]]></#{k}>"
      end
    end
    return "<xml>" + msg_arr.join("") + "</xml>"
  end
end
