# encoding: utf-8
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
Template.transaction do
  puts "\n导入模块"
  Template.delete_all
  templates = YAML.load_file("#{Rails.root}/db/basic_data/templates.yml")
  if !templates.blank?
    puts "create Template"
    templates.each do |k,v|
      Template.create(v)
      print "."
    end
  end

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
   puts "\n导入微壹平台数据数据"
   unless WeiyiConfig.find_by_number("about")
     WeiyiConfig.create(:number=>"about",:content=>"微壹是服务于幼儿园的校讯通平台。")
   end
end
