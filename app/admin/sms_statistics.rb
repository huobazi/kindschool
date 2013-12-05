#encoding:utf-8
#后台短信统计
ActiveAdmin.register_page "SmsStatistics" do
  menu :parent => "短信计费", :priority => 14, :label => proc{ I18n.t("active_admin.smsstatistics")  }
  content  do
    # collection_action :kind_sms_records, :method => :get, :title => "幼儿园" do
    # end
    columns do
      column do
        div do
          br
          @records = SmsRecord.search(params[:sms_record]).select('sms_records.*, messages.tp ,sum(sms_records.sms_count) as sum_count').joins("LEFT JOIN  message_entries ON(message_entries.id = sms_records.message_entry_id) LEFT JOIN messages ON(message_entries.message_id = messages.id)").group('sms_records.kindergarten_id').group('messages.tp').where(:status=>1).page(params[:page] || 1).per(10).order("sms_records.created_at DESC")
          render :partial => "/admin/sms_statistics/index" ,:locals=>{:sms_records=>@records}
        end
      end
    end
  end
end