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
              :Articles=>[{:Title=>"幼儿园介绍",:Description=>"#{@kind.note}",:PicUrl=>"http://#{request.host_with_port}#{@kind.asset_img ? @kind.asset_img.public_filename(:tiny) : '/t/colorful/logo.png'}",:Url=>"http://#{request.host_with_port}/weixin/about?#{get_validate_string}"}],
              :FuncFlag=>0
            })
        elsif xml_data[:Content] == "4"
          x_data =mas_data({:ToUserName=>xml_data[:FromUserName],
              :FromUserName=>xml_data[:ToUserName],
              :CreateTime=>Time.now.to_i,
              :MsgType=>"text",
              :Content=>"#{current_user.name}您好!近期菜谱: \n\r #{get_read_cook_books}",
              :FuncFlag=>0
            })
        elsif xml_data[:Content] == "5"
          albums = @kind.albums.where(:is_show=>1).order("send_date DESC").limit(8)
          if albums.blank?
            x_data =mas_data({:ToUserName=>xml_data[:FromUserName],
                :FromUserName=>xml_data[:ToUserName],
                :CreateTime=>Time.now.to_i,
                :MsgType=>"text",
                :Content=>"#{current_user.name}您好! \n\r 没有相册集锦消息\r\n <a href=\"http://#{request.host_with_port}/weixin?#{get_validate_string}\"> 进入家园互动</a>",
                :FuncFlag=>0
              })
          else
            hash = {:ToUserName=>xml_data[:FromUserName],
              :FromUserName=>xml_data[:ToUserName],
              :CreateTime=>Time.now.to_i,
              :MsgType=>"news",
              :Content=>"照片集锦",
              :FuncFlag=>0
            }
            albums_data = []
            albums.each do |album|
              albums_data << {:Title=>"#{album.title}",:Description=>"",:PicUrl=>"http://#{request.host_with_port}#{album.show_main_img ? album.show_main_img.public_filename(:tiny) : '/t/colorful/login_img5.png'}",:Url=>"http://#{request.host_with_port}/weixin/albums/#{album.id}?#{get_validate_string}"}
            end
            hash[:Articles] = albums_data
            x_data = mas_data(hash)
          end
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
              :MsgType=>"news",
              :Content=>"#{@kind.name}",
              :ArticleCount=>1,
              :Articles=>[{:Title=>"幼儿园介绍",:Description=>"#{@kind.note}",:PicUrl=>"http://#{request.host_with_port}#{@kind.asset_img ? @kind.asset_img.public_filename(:tiny) : '/t/colorful/logo.png'}",:Url=>"http://#{request.host_with_port}/weixin/about?#{get_validate_string}"}],
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
      end
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
  def get_read_cook_books
    if cook_book = @kind.cook_books.order("start_at DESC").first
      return "近期菜谱:\r\n #{cook_book.start_at ? (cook_book.start_at.to_short_datetime + "\n\r ") : ""}#{cook_book.end_at ? ("至" + cook_book.end_at.to_short_datetime.to_s + "\n\r ") : ""} <a href=\"http://#{request.host_with_port}/weixin/cook_books?#{get_validate_string}\"> 点击查看</a>"
    else
      return "没有菜谱消息\r\n <a href=\"http://#{request.host_with_port}/weixin?#{get_validate_string}\"> 进入家园互动</a>"
    end
  end

  def mas_data(option = {})
    msg_arr = []
    option.each do |k,v|
      if k == "FuncFlag".to_sym
        msg_arr << "<#{k}>#{v}</#{k}>"
      elsif k == "Articles".to_sym
        msg_arr << "<ArticleCount><![CDATA[#{v.count}]]></ArticleCount>"
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
