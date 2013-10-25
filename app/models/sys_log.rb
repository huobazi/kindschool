#encoding:utf-8
#日志记录
class SysLog < ActiveRecord::Base
  attr_accessible :kindergarten_id, :method, :node, :original_url, :remote_ip, :url_chinese, :url_options, :url_params, :user_id
  belongs_to :kindergarten
  belongs_to :user #, :class_name => "User", :foreign_key => "user_id"

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
