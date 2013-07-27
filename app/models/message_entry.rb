#encoding:utf-8
class MessageEntry < ActiveRecord::Base
  acts_as_paranoid
  attr_accessible :content, :message_id, :phone, :receiver_id, :receiver_name, :sms, :status,:read_status

  belongs_to :message
  belongs_to :receiver, :class_name => "User",:foreign_key=>:receiver_id

  validates :receiver_id, :presence => true

  def read_status_label
    self.read_status ? "已读" : "未读"
  end

  def before_create
    if self.receiver
      self.receiver_name = self.receiver.name
    elsif self.receiver_id
      if user = User.find_by_id_and_kindergarten_id(self.receiver_id,self.kindergarten_id)
        self.receiver_name = user.name
      end
    end
  end

  #TODO:短信流程
  #1、增加幼儿园可收短信数量，和可收短信用户数量，GOOD
  #2、增加幼儿园设置收短息和发短信的人的功能
  #3、增加短息记录表
  #4、增加发送方法，发送方法需要考虑是否可发信人，和所有能收信人，关注扩展码控制
  #5、添加到异步方法
  #6、发送状态的控制
  #7、收信事件轮询获取
  #8、获取到的信息，根据扩展添加到发信息中

  
end
