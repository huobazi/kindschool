#sencoding:utf-8
ActiveAdmin.register SmsRecord do
  menu :parent => "短信计费", :priority => 14

  index do
    column :kindergarten_label
    column :sender_name
    column :receiver_name
    column :receiver_phone
    column :status do |record|
      SmsRecord::STATUS[record.status]
    end
    column :chain_code
    default_actions
  end

  filter :kindergarten
  filter :sender_name, :as => :string
  filter :receiver_name, :as => :string
  filter :status, :as => :select, :collection => SmsRecord::STATUS.invert
  filter :content
  filter :receiver_phone
  filter :created_at

  show do
    attributes_table do
      row :content do |sms_record|
        raw sms_record.content
      end
      row :sender_name
      row :receiver_name
      row :receiver_phone
      row :chain_code
      row :sms_count
      row :kindergarten_label
      row :status_label
      row :created_at
      row :updated_at
    end
  end
end
