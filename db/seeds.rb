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
    print "."
  end
  unless WeiyiConfig.find_by_number("contact")
    WeiyiConfig.create(:number=>"contact",:content=>"联系我们的介绍内容。")
    print "."
  end
  unless WeiyiConfig.find_by_number("weixin_validate")
    WeiyiConfig.create(:number=>"weixin_validate",:content=>"0")
    print "."
  end
  unless WeiyiConfig.find_by_number("web_weiyi_contact")
    WeiyiConfig.create(:number=>"web_weiyi_contact",:content=>"联系我们")
    print "."
  end
  unless WeiyiConfig.find_by_number("web_weiyi_interact")
    WeiyiConfig.create(:number=>"web_weiyi_interact",:content=>"家园互动")
    print "."
  end
  unless WeiyiConfig.find_by_number("web_weiyi_about")
    WeiyiConfig.create(:number=>"web_weiyi_about",:content=>"关于我们")
    print "."
  end
  unless WeiyiConfig.find_by_number("web_garden_about")
    WeiyiConfig.create(:number=>"web_garden_about",:content=>"园讯通文字介绍,园讯通文字介绍园讯通文字介绍园讯通文字介绍园讯通文字介绍园讯通文字介绍园讯通文字介绍园讯通文字介绍园讯通文字介绍园讯通文字介绍园讯通文字介绍园讯通文字介绍园讯通文字介绍园讯通文字介绍园讯通文字介绍园讯通文字介绍园讯通文字介绍园讯通文字介绍园讯通文字介绍园讯通文字介绍")
    print "."
  end
  unless WeiyiConfig.find_by_number("web_garden_kindergarten")
    WeiyiConfig.create(:number=>"web_garden_kindergarten",:content=>"推荐幼儿园")
    print "."
  end
  unless WeiyiConfig.find_by_number("web_garden_classic_users")
    WeiyiConfig.create(:number=>"web_garden_classic_users",:content=>"经典客户")
    print "."
  end
  unless WeiyiConfig.find_by_number("web_weiyi_video")
    WeiyiConfig.create(:number=>"web_weiyi_video",:content=>"移动视频")
    print "."
  end
  unless WeiyiConfig.find_by_number("web_weiyi_scheme")
    WeiyiConfig.create(:number=>"web_weiyi_scheme",:content=>"影视策划")
    print "."
  end
  unless WeiyiConfig.find_by_number("web_weiyi_cultivate")
    WeiyiConfig.create(:number=>"web_weiyi_cultivate",:content=>"动漫培训")
    print "."
  end
  unless WeiyiConfig.find_by_number("web_weiyi_benefit")
    WeiyiConfig.create(:number=>"web_weiyi_benefit",:content=>"公益活动")
    print "."
  end
  unless WeiyiConfig.find_by_number("weiyi_seo_description")
    WeiyiConfig.create(:number=>"weiyi_seo_description",:content=>"微一资讯,微服务，从事移动互联网的校讯通服务。")
    print "."
  end
  unless WeiyiConfig.find_by_number("weiyi_seo_keywords")
    WeiyiConfig.create(:number=>"weiyi_seo_keywords",:content=>"园讯通,校讯通,深圳校讯通,微一资讯,微壹资讯,微壹资讯科技,幼儿园微信,微信幼儿园,微信服务平台,免费校讯通,免费服务幼儿园")
    print "."
  end
end
