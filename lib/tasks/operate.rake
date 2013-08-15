#encoding:utf-8
# 添加Operate数据
namespace :db do
  desc 'create operate data'
  task :operate => :environment do
    puts "\n导入权限"
    Operate.delete_all
    operates = YAML.load_file("#{Rails.root}/db/basic_data/operates.yml")
    if !operates.blank?
      puts "create Operate"
      operates.delete("DEFAULTS")
      operates.each do |k,v|
        Operate.create(v)
        print "."
      end
    end
  end
  task :menu=>:environment do
    puts "\n导入系统菜单数据"
    Menu.delete_all
    YAML::load(File.read("#{Rails.root}/db/basic_data/menus.yml")).each do |p|
      children = p.delete('children')
      menu = Menu.new(p)
      menu.id = p["id"]
      menu.save
      (children || []).each do |child|
        submenu = Menu.new(child)
        submenu.id = child["id"]
        menu.children << submenu
        print "."
      end
      puts ".\n"
    end
  end
end