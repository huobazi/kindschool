#encoding:utf-8
class MySchool::MainController < MySchool::BaseController
  before_filter :find_shrink_record
  #幼儿园首页
  #  layout "colorful_main"
  def index
    if @kind 
      @news = @kind.news.where(:approve_status=>0).limit(6)
      root_showcase = @kind.page_contents.find_by_number("official_website_home")
      if root_showcase && !root_showcase.content_entries.blank?
        @teacher_infos = root_showcase.content_entries.where(:number=>"official_home_teacher")
        @img= root_showcase.content_entries.where(:number=>'official_home_pub_img')     
      end
      @notices = @kind.notices.where(:send_range=>[0,2]).limit(6)
      if @kind.kind_zone
        today,new_today = Redis::Objects.redis.get("#{@kind.kind_zone.code}_today"),false
        if today
          today_time = Time.parse(today)
          if today_time <= Time.now && Time.now <= today_time.tomorrow
            new_today = true
          end
        end
        if new_today
          @temp_text = Redis::Objects.redis.get("#{@kind.kind_zone.code}")
        else
          begin
            weatherinfo = JSON.parse(open("http://m.weather.com.cn/data/#{@kind.kind_zone.code}.html").read)
            if weatherinfo && weatherinfo['weatherinfo']
              weather = {'city' => weatherinfo['weatherinfo']['city'], 'temp1' => weatherinfo['weatherinfo']['temp1'], 'index_d' => weatherinfo['weatherinfo']['index_d']}
              @temp_text = "#{weather['city']} #{weather['temp1']} #{weather['index_d']}"
              Redis::Objects.redis.set("#{@kind.kind_zone.code}", @temp_text)
              Redis::Objects.redis.set("#{@kind.kind_zone.code}_today", Time.now)
            end
          rescue Exception => e
          end
        end
      end
    end
  end

  #提示界面
  def no_kindergarten
    render :layout=>"colorful_main"
  end
  #关于我们
  def about
    #    render :layout=>"colorful_main"
  end
  #联系我们
  def contact_us
    #    render :layout=>"colorful_main"
  end

  #官网里面的圆所特色
  def feature
    if @kind 
      root_showcase = @kind.page_contents.find_by_number("official_website_feature") 
      if root_showcase && !root_showcase.content_entries.blank?
        @content_entries = root_showcase.content_entries
      end
    end
  end

  #显示关于官网里面的关于幼儿园
  def show_official_about_us
    if @kind 
      root_showcase = @kind.page_contents.find_by_number("official_website_about_us") 
      if root_showcase && !root_showcase.content_entries.blank?
        if content_entries = root_showcase.content_entries
          @entry = content_entries.find_by_number("official_website_about_us_content")
          @entry_title = content_entries.find_by_number("official_website_about_us_title")
          @entry_img = content_entries.find_by_number("official_website_about_us_img")
          @entry_top = content_entries.find_by_number("official_website_about_us_img_top")
          @entry_bottom = content_entries.find_by_number("official_website_about_us_img_bottom")
        end
      end
    end
  end
  #显示官网招生信息
  def admissions_information
    if @kind 
      root_showcase = @kind.page_contents.find_by_number("official_website_admissions_information") 
      if root_showcase && !root_showcase.content_entries.blank?
        @entry = root_showcase.content_entries.find_by_number("official_website_admissions_title")   
        @entry_mid = root_showcase.content_entries.find_by_number("official_website_admissions_mid_title")
      end
    end
  end

  def show_one_new
    @new = @kind.news.find(params[:new_id])
    @new.show_count = @new.show_count.to_i+1
    @new.save
    @new_pre = @kind.news.find(:first,:conditions=>["created_at>:create_at",{:create_at=>@new.created_at}])
    @new_next = @kind.news.find(:first,:conditions=>["created_at<:create_at",{:create_at=>@new.created_at}])
  end

  def show_new_list
    @news = @kind.news.where(:approve_status=>0).page(params[:page] || 1).per(10)
  end

  #给院长发邮件
  def dean_email
    @dean_email = DeanEmail.new
  end
  
  #创建院长发邮件
  def create_dean_email
    if @kind.has_choose_operate?(11100)
      @dean_email = DeanEmail.new(params[:dean_email])
      @dean_email.kindergarten_id = @kind.id
      if @dean_email.save
        flash[:notice] = "邮件发送成功，请等待园长查收邮件后给您回复。"
        redirect_to :action => "dean_email_list"
      else
        render :action=>:dean_email
      end
    else
      flash[:error] = "园长信箱未启用。"
      redirect_to :action => "index"
    end
  end

  def dean_email_list
    @dean_emails = @kind.dean_emails.where(:visible=>1).page(params[:page] || 1).per(10)
  end
  
  #查看邮件
  def dean_email_show
    @dean_email = @kind.dean_emails.find(params[:dean_email_id],:conditions=>"visible=1")
  end

  def show_cookbooks
    @can_show = @kind.show_cookbook
    if @kind.show_cookbook
      @cookbooks = @kind.cook_books.page(params[:page] || 1).per(1).order("created_at DESC")
    end
  end

  def show_wonderful_episodes
    @wonderful_episodes = @kind.wonderful_episodes.page(params[:page] || 1).per(10).order("created_at DESC")
  end

  def show_policies
    @menu = "policy"
    if @kind.kind_zone
      @policies = @kind.kind_zone.policies.page(params[:page] || 1).per(10).order("created_at DESC")
    end
  end

  def show_policy
    @menu = "policy"
    if @kind.kind_zone
      @policy = @kind.kind_zone.policies.find_by_id(params[:id])
    end
  end

  def show_wonderful_episode
    @wonderful_episode = @kind.wonderful_episodes.find_by_id(params[:id])
  end

  private
  def find_shrink_record
    if @kind && @kind.shrink_record
      @keywords = @kind.shrink_record.keywords
      @description = @kind.shrink_record.description
    end
    @menu = "home"
    data = HOME_MENU || []
    data.each do |menu,value|
      if arr = value[controller_path.to_s]
        if arr.include?(action_name.to_s)
          @menu = menu
          break
        end
      end
    end
  end

end
