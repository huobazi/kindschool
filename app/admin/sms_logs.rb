#sencoding:utf-8
ActiveAdmin.register SmsLog do
  menu :parent => "短信计费", :priority => 14

  index do
    column :kindergarten
    column :tp do |sms_log|
      SmsLog::TP_DATA[sms_log.tp.to_s]
    end
    column :count
    column :user
    column :admin_user
    column :note
    column :created_at
    default_actions
  end

  filter :kindergarten
  filter :tp, :as => :select, :collection => SmsLog::TP_DATA.invert

  show do |sms_log|
    attributes_table do
      row :kindergarten
      row :tp do 
        SmsLog::TP_DATA[sms_log.tp.to_s]
      end
      row :count
      row :user
      row :admin_user
      row :message_id do
        sms_log.try(:message).try(:get_full_message)
      end
      row :note
      row :created_at
    end
  end
end
