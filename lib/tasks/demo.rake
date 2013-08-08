#encoding:utf-8
# 添加demo数据
namespace :db do
  desc 'create demo data'
  task :demo => :environment do
    template = Template.find_by_is_default(true)
    puts "添加幼儿园"
    #添加幼儿园
    kind = Kindergarten.create!(:name=>"火龙果幼儿园",:number=>"huolg",:template_id=>template.id,:note=>"这是幼儿园简介",:weixin_token=>"weiyi",:weixin_status=>1,:sms_count=>50,:sms_user_count=>50,:telephone=>"0755-86081688",:latlng=>"22.509512,113.939267",:address=>"幼儿园地址")
    kind.loading!
    puts "添加管理员"
    #添加管理员
    User.create!(:login=>"huolg",:phone=>"18938681985",:is_send=>true,:name=>"幼儿园管理员",:note=>"我是管理员",:tp=>2,:password=>"111111",:password_confirmation=>"111111",:kindergarten_id=>kind.id)
    puts "添加教职工"
    kind.reload
    #添加5个教职工
    (1..5).to_a.each do |i|
      user = User.new(:login=>"staff#{i}",:phone=>"1397677198#{i}",:name=>"教职工#{i}",:note=>"我是教职工#{i}",:tp=>1,:password=>"111111",:password_confirmation=>"111111",:kindergarten_id=>kind.id)
      user.role = kind.roles.random
      user.staff = Staff.new(:card_code=>"1000#{i}")
      user.save!
      print "."
    end
    puts "添加年级"
    #添加年级
    (1..3).to_a.each do |i|
      grade = Grade.new(:kindergarten_id=>kind.id,:name=>"#{i}年级",:note=>"这是#{i}年级",:staff_id=>kind.staffs.random.id)
      grade.save!
      print "."
    end
    puts "添加班级"
    #添加班级
    (1..10).to_a.each do |i|
      squad = Squad.new(:name=>"班级#{i}",:note=>"这是班级#{i}",:grade_id=>kind.grades[(i % 3)].id,:kindergarten_id=>kind.id,:historyreview=>"2013")
      squad.save!
      print "."
    end
    puts "关联负责老师"
    #关联负责老师
    kind.squads.each do|squad|
      squad.teachers << Teacher.new(:staff_id=>kind.staffs.random.id)
      squad.save!
      print "."
    end
    
    puts "添加学生"
    #添加6个学生
    (1..60).to_a.each do |i|
      user = User.create!(:weixin_code=>i == 1 ? "ofHgAj0UF75WoUvgUC-9dtccnYf4" : "weixin_code#{i}",:phone=>"139764719#{i / 10 == 0 ? ("0" + i.to_s) : i }",:name=>"学生#{i}",:note=>"我是学生#{i}",:tp=>0,:password=>"111111",:password_confirmation=>"111111",:kindergarten_id=>kind.id,:tp=>0)
      StudentInfo.create!(:card_code=>"1000#{i}",:birthday=>Time.now,:squad_id=>kind.squads.random.id,:user_id=>user.id,:kindergarten_id=>kind.id)
      print "."
    end
    puts "demo添加完毕."
  end
end