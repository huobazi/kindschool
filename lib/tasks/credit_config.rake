#encoding:utf-8
# 添加积分商城配置任务
namespace :db do
  desc 'create credit_config data'
    task :credit_config => :environment do
      puts "\n后台积分配置"  
      credit_configs = YAML.load_file("#{Rails.root}/db/basic_data/credit_config.yml")
      unless credit_configs.blank?
        credit_configs.each do |k,v|
          CreditCofig.create(v)
        end
      end
    end
end