#encoding:utf-8
#日志记录
class SysLog < ActiveRecord::Base
  attr_accessible :kindergarten_id, :method, :node, :original_url, :remote_ip, :url_chinese, :url_options, :url_params, :user_id
  belongs_to :kindergarten
  belongs_to :user #, :class_name => "User", :foreign_key => "user_id"

  class << self
    attr_accessor :syslog_list
    attr_accessor :syslogkeys
  end

  def self.init_syslog_list
    self.syslog_list = {
      "topics" => {
        "name" => "贴子",
        "count" => 0,
        "text" => ""
      },
      "messages" => {
        "name" => "消息",
        "count" => 0,
        "text" => ""
      },
      "garden_growth_records" => {
        "name" => "宝宝在园成长记录",
        "count" => 0,
        "text" => ""
      },
      "growth_records" => {
        "name" => "宝宝在家成长记录",
        "count" => 0,
        "text" => ""
      },
      "comment" => {
        "name" => "评论",
        "count" => 0,
        "text" => ""
      },
      "cook_books" => {
        "name" => "菜谱",
        "count" => 0,
        "text" => ""
      },
      "physical_records" => {
        "name" => "体检记录",
        "count" => 0,
        "text" => ""
      },
      "seedlings" => {
        "name" => "疫苗记录",
        "count" => 0,
        "text" => ""
      },
      "teaching_plans" => {
        "name" => "教学计划",
        "count" => 0,
        "text" => ""
      },
      "albums" => {
        "name" => "相册集锦",
        "count" => 0,
        "text" => ""
      },
      "activities" => {
        "name" => "活动",
        "count" => 0,
        "text" => ""
      }
    }
    self.syslogkeys = SYSLOGS.keys.map {|sk| sk.split("/").last }
  end

  # 计算并输出各种操作对象的数量
  def self.output_syslog(teacher, start_at=nil, end_at=nil)
    self.init_syslog_list
    if start_at.present? && end_at.present?
      syslogs = SysLog.where("user_id = ? and created_at >= ? and created_at <= ?", teacher.try(:user_id), start_at, end_at)
    else
      syslogs = SysLog.where(:user_id => teacher.try(:user_id))
    end
    unless syslogs.blank?
      syslogs.each do |syslog|
        record_controller = syslog.url_options.split("controller: ").last.chomp
        record_name = record_controller.split("/").last.chomp
        record_actions = /action:\s(\w+)\b/.match(syslog.url_options)[1]
        record_method = syslog.method
        if self.syslogkeys.include?(record_name) && SYSLOGS.keys.include?(record_controller)
          self.syslog_list[record_name]["count"] += 1
          if self.syslog_list[record_name]["text"].blank?
            self.syslog_list[record_name]["text"] = SYSLOGS[record_controller][record_actions][record_method]
          end
        end
      end
      text = ""
      (self.syslog_list.values || []).each do |sl|
        if sl["count"] > 0
          text += "<p>#{sl["text"]}数量:<span class='text-info'>#{sl["count"]}<span><p>"
        end
      end
      return text
    else
      return "<p class='muted'>没有任何操作记录</p>"
    end
  end

  def self.write_log(current_user_id,url,method,original_url,remote_ip,params,kind_id)
      logtrail=SysLog.new
      controller = url[:controller]
      action = url[:action]
      if SYSLOGS[controller] && SYSLOGS[controller][action]
        syslog=SYSLOGS[controller][action][method]
        logtrail.url_chinese=syslog
        logtrail.kindergarten_id=kind_id
        logtrail.user_id=current_user_id
        logtrail.url_options=url
        logtrail.method=method
        logtrail.original_url=original_url
        logtrail.remote_ip=remote_ip
        logtrail.url_params=params.inspect
        if syslog == "发送消息"
         if user = User.select(:name).where(:id=>params[:ids])#.size#.collect(&:name)#.collect(&name)
         user_size=user.size
         user_names = user[0...30].collect(&:name)
         unless params[:message].blank?
           logtrail.node = "发送消息给#{user_size}人,#{params[:message][:tp]==1 ? '是' : '否'}发短信,#{params[:message][:send_me] ? '是' : '否'}发给自己,#{params[:message][:allsms]=="1" ? '是' : '否'}发给所有人,发消息给#{user_names.join(",")}(#{user_size>30 ? "后续省略" : "全部"})"
         end
         end
        end
        logtrail.save
      end
  end

end
