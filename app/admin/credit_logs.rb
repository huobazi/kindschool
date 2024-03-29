#encoding:utf-8
ActiveAdmin.register CreditLog do
  menu :parent => "积分商城", :priority => 15

  index do
    column :kindergarten
    column :tp do |t|
      CreditLog::TP[t.tp]
    end
    column :credit
    column :note
    column :resource
    column :business
    # default_actions
  end

  filter :kindergarten

  show do |menu|
    attributes_table do
      row :kindergarten
      row :tp do |t|
        CreditLog::TP[t.tp]
      end
      row :credit
      row :note
      row :resource
      row :business
    end
  end
end


