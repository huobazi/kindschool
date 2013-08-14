#encoding:utf-8
# 获取短信回复
namespace :sms do
  desc 'load sms data'
  task :load => :environment do
    #数据结构 ["2013-06-28 14:54:57.0##0##18938681985##看看就看看","2013-06-28 14:54:57.0##0##18938681985##看看就看看"]
    sms_data = ShortMessage.get_sms_data
    if sms_data != "error"
      sms_data.each do |data|
        meg = data.split("##")
        if user = User.find_by_phone(meg[2])
          if record = SmsRecord.find(:first,:conditions=>["receiver_id=:receiver_id",{:receiver_id=>user.id,:chain_code=>meg[1]}],:order=>"id DESC")
            if record.message_entry && (message = record.message_entry.message)
              message_record = Message.new(:kindergarten_id=>record.kindergarten_id,:title=>"短信回复",:entry_id=>message.id,:content=>meg[3],:status=>1,:tp=>0,:sender_id=>user.id,:send_date=>Time.now)
              message_record.message_entries << MessageEntry.new(:receiver_id=>message.sender_id)
              message_record.save
            end
          end
        end
      end
    end
    puts "短信回复获取完毕.#{Time.now}"
  end
end