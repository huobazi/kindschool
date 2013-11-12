#sencoding:utf-8
ActiveAdmin.register SmsRecord do
menu :parent => "短信计费", :priority => 14

index do
column :kindergarten
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
end