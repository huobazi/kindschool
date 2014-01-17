#encoding:utf-8
class Weixin::ApiController < Weixin::BaseController
  protect_from_forgery :except=>:index
  #  include AuthenticatedSystem
  before_filter :token_validate , :if=>proc {|c| (is_www? && weiyi_token_validate?) || (!is_www? && @kind.weixin_status == 0)}
  #交互接口
  def index
    if is_www?
      load_platform
    else
      load_school
    end
  end

  protected
  #微壹是否需要验证
  def weiyi_token_validate?
    if weiyi_config = WeiyiConfig.find_by_number("weixin_validate")
      return weiyi_config.content == "1"
    else
      return false
    end
  end
  #学校api接口
  def load_school
    if xml_data = params[:xml]
      #关注
      if xml_data[:Event] == "subscribe"
        x_data = mas_data({:ToUserName=>xml_data[:FromUserName],
            :FromUserName=>xml_data[:ToUserName],
            :CreateTime=>Time.now.to_i,
            :MsgType=>"text",
            :Content=>"欢迎关注#{@kind.name} \n #{get_menu} ",
            :FuncFlag=>0
          })
      elsif xml_data[:Event] == "unsubscribe"
        user = User.find_by_weixin_code(xml_data[:FromUserName])
        if user
          user.update_attribute(:weixin_code,nil)
        end
      else
        if logged_in?
          if xml_data[:MsgType] == "text" || xml_data[:MsgType] == "voice"
            #查看消息
            if xml_data[:Content] == "1"
              #未读消息
              x_data =mas_data({:ToUserName=>xml_data[:FromUserName],
                  :FromUserName=>xml_data[:ToUserName],
                  :CreateTime=>Time.now.to_i,
                  :MsgType=>"text",
                  :Content=>"#{current_user.name}您好! \n #{get_read_new_message}",
                  :FuncFlag=>0
                })
            elsif xml_data[:Content] == "2"
              #幼儿园介绍
              x_data = mas_data({:ToUserName=>xml_data[:FromUserName],
                  :FromUserName=>xml_data[:ToUserName],
                  :CreateTime=>Time.now.to_i,
                  :MsgType=>"news",
                  :Content=>"#{@kind.name}",
                  :Articles=>[{:Title=>"幼儿园介绍",:Description=>"",:PicUrl=>"http://#{request.host_with_port}/t/colorful/weixin_ad.png",:Url=>"http://#{request.host_with_port}/weixin/about?#{get_validate_string}"},{:Title=>"幼儿园介绍",:Description=>"#{@kind.note}",:PicUrl=>"http://#{request.host_with_port}#{@kind.asset_img ? @kind.asset_img.public_filename(:tiny) : '/t/colorful/logo.png'}",:Url=>"http://#{request.host_with_port}/weixin/about?#{get_validate_string}"}],
                  :FuncFlag=>0
                })
            elsif xml_data[:Content] == "3"
              #菜谱信息
              x_data =mas_data({:ToUserName=>xml_data[:FromUserName],
                  :FromUserName=>xml_data[:ToUserName],
                  :CreateTime=>Time.now.to_i,
                  :MsgType=>"text",
                  :Content=>"#{current_user.name}您好!班级主题活动: \n <a href=\"http://#{request.host_with_port}/weixin/activities?#{get_validate_string}\"> 进入家园互动</a>",
                  :FuncFlag=>0
                })
            elsif xml_data[:Content] == "4"
              #菜谱信息
              x_data =mas_data({:ToUserName=>xml_data[:FromUserName],
                  :FromUserName=>xml_data[:ToUserName],
                  :CreateTime=>Time.now.to_i,
                  :MsgType=>"text",
                  :Content=>"#{current_user.name}您好!近期菜谱: \n #{get_read_cook_books}",
                  :FuncFlag=>0
                })
            elsif xml_data[:Content] == "5"
              #照片集锦
              albums = @kind.albums.where(:is_show=>1).order("send_date DESC").limit(8)
              if albums.blank?
                x_data =mas_data({:ToUserName=>xml_data[:FromUserName],
                    :FromUserName=>xml_data[:ToUserName],
                    :CreateTime=>Time.now.to_i,
                    :MsgType=>"text",
                    :Content=>"#{current_user.name}您好! \n 没有相册集锦消息 \n <a href=\"http://#{request.host_with_port}/weixin?#{get_validate_string}\"> 进入家园互动</a>",
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
            elsif xml_data[:Content] == "6"
              #宝宝成长
              x_data =mas_data({:ToUserName=>xml_data[:FromUserName],
                  :FromUserName=>xml_data[:ToUserName],
                  :CreateTime=>Time.now.to_i,
                  :MsgType=>"text",
                  :Content=>"#{current_user.name}您好! \n 查看宝宝成长信息 \n <a href=\"http://#{request.host_with_port}/weixin/garden_growth_records?#{get_validate_string}\"> 点击进入</a>",
                  :FuncFlag=>0
                })
            else
              content_data = ""
              if xml_data[:MsgType]=="voice"
                content_data = xml_data[:Recognition] if xml_data[:Recognition].size > 5
              else
                content_data = xml_data[:Content]
              end
              if content_data.size > 5
                text = TextSet.new(:content=>content_data)
                personal = PersonalSet.new()
                personal.resource = text
                current_user.personal_sets << personal
                if current_user.save
                  url_garden = (current_user.get_users_ranges[:tp] == :student) ? "http://#{request.host_with_port}/weixin/growth_records/new?#{get_validate_string}personal_set_id=#{personal.id}" : "http://#{request.host_with_port}/weixin/garden_growth_records/new?#{get_validate_string}personal_set_id=#{personal.id}"
                  x_data =mas_data({:ToUserName=>xml_data[:FromUserName],
                      :FromUserName=>xml_data[:ToUserName],
                      :CreateTime=>Time.now.to_i,
                      :MsgType=>"text",
                      :Content=>"#{current_user.name}您好! \n 文字记录上传成功，您可以在照片集锦的个人集锦中查看。 \n 点击链接分享到成长记录: \n <a href=\"#{url_garden}\">添加到成长记录</a>",
                      :FuncFlag=>0
                    })
                end
              else
                x_data = mas_data({:ToUserName=>xml_data[:FromUserName],
                    :FromUserName=>xml_data[:ToUserName],
                    :CreateTime=>Time.now.to_i,
                    :MsgType=>"text",
                    :Content=>"欢迎关注#{@kind.name} \n #{get_menu} ",
                    :FuncFlag=>0
                  })
              end
            
            end

          elsif xml_data[:MsgType] == "image"
            photo = PhotoGallery.new
            photo.source_uri= "#{xml_data[:PicUrl]}.jpg"
            personal = PersonalSet.new()
            personal.resource = photo
            personal.user_id = current_user.id
            if personal.save
              url_garden = (current_user.get_users_ranges[:tp] == :student) ? "http://#{request.host_with_port}/weixin/growth_records/new?#{get_validate_string}personal_set_id=#{personal.id}" : "http://#{request.host_with_port}/weixin/garden_growth_records/new?#{get_validate_string}personal_set_id=#{personal.id}"
              x_data = mas_data({:ToUserName=>xml_data[:FromUserName],
                  :FromUserName=>xml_data[:ToUserName],
                  :CreateTime=>Time.now.to_i,
                  :MsgType=>"text",
                  :Content=>"#{current_user.name}您好! \n 照片上传成功，您可以在照片集锦的个人集锦中查看。点击链接分享到成长记录: \n<a href=\"#{url_garden}\">添加到成长记录</a>",
                  :FuncFlag=>0
                })
            end
          else
            x_data = mas_data({:ToUserName=>xml_data[:FromUserName],
                :FromUserName=>xml_data[:ToUserName],
                :CreateTime=>Time.now.to_i,
                :MsgType=>"text",
                :Content=>"欢迎关注#{@kind.name} \n #{get_menu} ",
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
                :Content=>"欢迎关注#{@kind.name} \n 点击以下链接绑定账号： \n <a href=\"http://#{request.host_with_port}/weixin/main/bind_user?#{get_validate_string}code=#{xml_data[:FromUserName]}\"> 点击绑定</a>",
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
                :Articles=>[{:Title=>"幼儿园介绍",:Description=>"",:PicUrl=>"http://#{request.host_with_port}/t/colorful/weixin_ad.png",:Url=>"http://#{request.host_with_port}/weixin/about?#{get_validate_string}"},{:Title=>"幼儿园介绍",:Description=>"#{@kind.note}",:PicUrl=>"http://#{request.host_with_port}#{@kind.asset_img ? @kind.asset_img.public_filename(:tiny) : '/t/colorful/logo.png'}",:Url=>"http://#{request.host_with_port}/weixin/about?#{get_validate_string}"}],
                :FuncFlag=>0
              })
          else
            x_data = mas_data({:ToUserName=>xml_data[:FromUserName],
                :FromUserName=>xml_data[:ToUserName],
                :CreateTime=>Time.now.to_i,
                :MsgType=>"text",
                :Content=>"欢迎关注#{@kind.name} \n #{get_menu} ",
                :FuncFlag=>0
              })
          end
        end
      end
    end
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
    if xml_data = params[:xml]
      if xml_data[:Event] == "subscribe"
        x_data = mas_data({:ToUserName=>xml_data[:FromUserName],
            :FromUserName=>xml_data[:ToUserName],
            :CreateTime=>Time.now.to_i,
            :MsgType=>"text",
            :Content=>"微服务，一公益 \n #{get_weiyi_menu} ",
            :FuncFlag=>0
          })
      elsif xml_data[:Event] == "CLICK"
        if xml_data[:EventKey] == "Bind"
          x_data = weiyi_bind(xml_data)
        elsif xml_data[:EventKey] == "About"
          x_data = weiyi_about(xml_data)
        elsif xml_data[:EventKey] == "Contact"
          x_data = weiyi_about(xml_data,"contact")
        else
          x_data = mas_data({:ToUserName=>xml_data[:FromUserName],
              :FromUserName=>xml_data[:ToUserName],
              :CreateTime=>Time.now.to_i,
              :MsgType=>"text",
              :Content=>"微服务，一公益 \n #{get_weiyi_menu} ",
              :FuncFlag=>0
            })
        end
      elsif xml_data[:Event] == "unsubscribe"
        if user = User.find_by_weiyi_code(xml_data[:FromUserName])
          session[:weiyi_code] = nil
          user.update_attribute(:weiyi_code,nil)
        end
      else
        if xml_data[:Content] == "1"
          x_data = weiyi_bind(xml_data)
        elsif xml_data[:Content] == "2"
          x_data = weiyi_about(xml_data)
        elsif xml_data[:Content] == "3"
          x_data = weiyi_about(xml_data,"contact")
        else
          if xml_data[:MsgType]=="voice"
            load_bol = true
            if user = User.find_by_weiyi_code(xml_data[:FromUserName])
              if weixin_token = WeixinToken.find_by_number("weiyizixun")
                audio = weixin_token.down_media(xml_data[:MediaId])
                if audio != "error"
                  text = TextSet.new(:content=>xml_data[:Recognition],:tp=>1,:audio=>"#{audio}.amr",:audio_turn=>"#{audio}.mp3")
                  personal = PersonalSet.new()
                  personal.resource = text
                  user.personal_sets << personal
                  load_bol = false if user.save
                end
              end
            end
            if load_bol
              x_data =mas_data({:ToUserName=>xml_data[:FromUserName],
                  :FromUserName=>xml_data[:ToUserName],
                  :CreateTime=>Time.now.to_i,
                  :MsgType=>"text",
                  :Content=>"#{user.name}您好! \n 语音记录上传失败，请重试。",
                  :FuncFlag=>0
                })
            else
              x_data =mas_data({:ToUserName=>xml_data[:FromUserName],
                  :FromUserName=>xml_data[:ToUserName],
                  :CreateTime=>Time.now.to_i,
                  :MsgType=>"text",
                  :Content=>"#{user.name}您好! \n 语音记录上传成功，您可以在照片集锦的个人集锦中查看。",
                  :FuncFlag=>0
                })
            end
          else
            x_data = mas_data({:ToUserName=>xml_data[:FromUserName],
                :FromUserName=>xml_data[:ToUserName],
                :CreateTime=>Time.now.to_i,
                :MsgType=>"text",
                :Content=>"微服务，一公益 \n #{get_weiyi_menu} ",
                :FuncFlag=>0
              })
          end
        end
      end
    end
    render :text=>x_data
  end

  private

  def weiyi_about(xml_data,tp="about")
    if tp == "about"
      if config = WeiyiConfig.find_by_number("about")
        about = config.content
      end
    else
      if contact = WeiyiConfig.find_by_number("contact")
        about = contact.content
      end
    end
    mas_data({:ToUserName=>xml_data[:FromUserName],
        :FromUserName=>xml_data[:ToUserName],
        :CreateTime=>Time.now.to_i,
        :MsgType=>"text",
        :Content=>"微服务，一公益 \n #{about}",
        :FuncFlag=>0
      })
  end
  
  def weiyi_bind(xml_data)
    #绑定
    if User.find_by_weiyi_code(xml_data[:FromUserName])
      mas_data({:ToUserName=>xml_data[:FromUserName],
          :FromUserName=>xml_data[:ToUserName],
          :CreateTime=>Time.now.to_i,
          :MsgType=>"text",
          :Content=>"微服务，一公益 \n 您的账户已绑定成功",
          :FuncFlag=>0
        })
    else
      mas_data({:ToUserName=>xml_data[:FromUserName],
          :FromUserName=>xml_data[:ToUserName],
          :CreateTime=>Time.now.to_i,
          :MsgType=>"text",
          :Content=>"微服务，一公益 \n 点击以下链接绑定账号： \n <a href=\"http://#{request.host_with_port}/weixin/main/bind_weiyi?#{get_validate_string}code=#{xml_data[:FromUserName]}\"> 点击绑定</a>",
          :FuncFlag=>0
        })
    end
  end

  def token_validate
    render :text=>params[:echostr]
    return
  end

  def get_menu
    if logged_in?
      "回复以下数字进行操作： \n 1、查看消息 \n 2、幼儿园介绍 \n 3、班级活动 \n 4、每周菜谱 \n 5、照片集锦 \n 6、宝宝成长 \n h、查看菜单"
    else
      "回复以下数字进行操作： \n 1、进行账号绑定 \n 2、幼儿园介绍 \n h、查看菜单"
    end
  end
  
  def get_weiyi_menu
    "1、进行账号绑定 \n 2、平台介绍 \n 3、联系我们"
  end

  def get_read_new_message
    count = current_user.get_read_new_count
    if count > 0
      return "您有#{count}条未读消息 \n <a href=\"http://#{request.host_with_port}/weixin/messages?#{get_validate_string}\"> 点击查看</a>"
    else
      return "您没有未读消息 \n 点击以下链接查看: \n <a href=\"http://#{request.host_with_port}/weixin/messages?#{get_validate_string}\"> 查看历史消息</a>"
    end
  end
  def get_read_cook_books
    if cook_book = @kind.cook_books.order("start_at DESC").first
      return "近期菜谱: \n 点击以下链接查看: \n #{cook_book.start_at ? (cook_book.start_at.to_short_datetime + " \n ") : ""}#{cook_book.end_at ? ("至" + cook_book.end_at.to_short_datetime.to_s + " \n ") : ""} <a href=\"http://#{request.host_with_port}/weixin/cook_books?#{get_validate_string}\"> 点击查看</a>"
    else
      return "没有菜谱消息 \n <a href=\"http://#{request.host_with_port}/weixin?#{get_validate_string}\"> 进入家园互动</a>"
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
