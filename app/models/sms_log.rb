#encoding:utf-8
#短信消费日志表
class SmsLog < ActiveRecord::Base
  attr_accessible :count, :user_id,:admin_user_id, :kindergarten_id, :tp, :message_id,:note

  belongs_to :kindergarten
  belongs_to :message
  belongs_to :user, :class_name => "User" #发送人
  belongs_to :admin_user, :class_name => "AdminUser" #处理人

  validates :kindergarten_id, :presence => true

  after_create :loading_sms

  TP_DATA = {"0"=>"消耗短信","1"=>"系统处理","2"=>"月结短信","3"=>"每月免费短信","4"=>"付费用户消费"}

  #所有幼儿园的短信月结
  def self.monthly_balance
    Kindergarten.all.each do |kind|
      self.load_monthly_balance_kind(kind)
    end
  end

  #指定某个幼儿园的短信月结
  def  self.monthly_balance_kind(kind_id)
    if kind = Kindergarten.find_by_id(kind_id)
      self.load_monthly_balance_kind(kind)
    end
  end

  def self.pay_count(kind_id,count,admin_user_id)
    if kind = Kindergarten.find_by_id(kind_id)
      SmsLog.create(:count=>count,:kindergarten_id=>kind.id,:admin_user_id=>admin_user_id,:tp=>1,:note=>"系统添加短信#{count}条")
    end
  end

  protected
  #处理幼儿园月结
  def self.load_monthly_balance_kind(kind)
    if smslog = SmsLog.find(:last,:conditions=>["kindergarten_id=:kind AND tp=2",{:kind=>kind.id}])
      if smslog.created_at.strftime("%Y-%m") != Time.now().strftime("%Y-%m")
        use_count = SmsLog.where(["id>:smslog AND tp=0 AND kindergarten_id=:kind",{:kind=>kind.id,:smslog=>smslog.id}]).sum(:count)
        free_count = SmsLog.where(["id>:smslog AND tp=3 AND kindergarten_id=:kind",{:kind=>kind.id,:smslog=>smslog.id}]).sum(:count)
        buy_count = SmsLog.where(["id>:smslog AND tp=1 AND kindergarten_id=:kind",{:kind=>kind.id,:smslog=>smslog.id}]).sum(:count)
        vip_count = SmsLog.where(["id>:smslog AND tp=4 AND kindergarten_id=:kind",{:kind=>kind.id,:smslog=>smslog.id}]).sum(:count)
        balance_count = 0 #本月月结短信
        if use_count.abs > free_count
          balance_count = (smslog.count + buy_count + free_count) + use_count
          SmsLog.create(:count=>balance_count,:kindergarten_id=>kind.id,:tp=>2,:note=>"月结短信#{balance_count}条。上月月结条数:#{smslog.count}。上月免费条数:#{free_count}。使用条数:#{use_count}。购买条数:#{buy_count}。付费用户条数:#{vip_count}")
          SmsLog.create(:count=>kind.sms_count,:kindergarten_id=>kind.id,:tp=>3,:note=>"每月免费短信#{kind.sms_count}条")
          kind.update_attributes(:balance_count=> (kind.sms_count + balance_count)) #更新幼儿园的剩余短信数量
        else
          balance_count = (smslog.count + buy_count + free_count) + use_count
          surplus_count = free_count + use_count  #剩余免费条数
          SmsLog.create(:count=>(smslog.count + buy_count),:kindergarten_id=>kind.id,:tp=>2,:note=>"月结短信#{balance_count}条。上月月结条数:#{smslog.count}。上月免费条数:#{free_count}。使用条数:#{use_count}。购买条数:#{buy_count}。付费用户条数:#{vip_count}")
          SmsLog.create(:count=>surplus_count,:kindergarten_id=>kind.id,:tp=>3,:note=>"每月剩余免费短信#{surplus_count}条")
          replenish_count = 0
          if kind.sms_count > surplus_count
            replenish_count = kind.sms_count - surplus_count  #补足免费条数
            SmsLog.create(:count=>replenish_count,:kindergarten_id=>kind.id,:tp=>3,:note=>"每月补足免费短信#{replenish_count}条")
          end
          kind.update_attributes(:balance_count=> (balance_count + replenish_count)) #更新幼儿园的剩余短信数量
        end
      end
    else
      SmsLog.create(:count=>0,:kindergarten_id=>kind.id,:tp=>2,:note=>"月结短信0条")
      SmsLog.create(:count=>kind.sms_count,:kindergarten_id=>kind.id,:tp=>3,:note=>"每月免费短信#{kind.sms_count}条")
      kind.update_attributes(:balance_count=> kind.sms_count)#更新幼儿园的剩余短信数量
    end
  end

  #添加日志后执行幼儿园的剩余条数更新
  def loading_sms
    self.kindergarten.update_attributes(:balance_count=>(self.kindergarten.balance_count + self.count)) if self.tp != 4
  end
end
