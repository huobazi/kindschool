#encoding:utf-8
#奖品表日志
ActiveAdmin.register PrizeLog do
  menu :parent => "积分商城", :priority => 15

  index do
    column :kindergarten
    column :user
    column :resource
    column :stage_credit
    column :status
    # default_actions
  end

  filter :kindergarten

  show do |menu|
    attributes_table do
      row :kindergarten
      row :user
      row :resource
      row :stage_credit
      row :status
    end
  end
end