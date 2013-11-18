#encoding:utf-8
#后台短信统计
ActiveAdmin.register_page "SmsStatistics" do
menu :parent => "短信计费", :priority => 14
 content :title => proc{ I18n.t("active_admin.dashboard") } do
  controller do
  	def index
      @sms_records = SmsRecord.select('sum(sms_records.sms_count) as sum_count').joins("LEFT JOIN  message_entries ON(message_entries.id = sms_records.message_entry_id)").group('message_entries.message_id,kindergarten_id').where(:status=>1).order("created_at DESC")
      # render :partial => "/admin/sms_statistics/index" 
  	  index!
    end
  end
  # columns do
  # 	column do
  # 	  div do
  #           br
  #           render :partial => "/admin/sms_statistics/index"
  #         end
  #    end
  #   end
end
end