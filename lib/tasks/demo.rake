#encoding:utf-8
# 添加demo数据
namespace :db do
  desc 'create demo data'
  task :demo => :environment do
    template = Template.find_by_is_default(true)
    puts "添加幼儿园"
    #添加幼儿园
    kind = Kindergarten.create(:name=>"火龙果幼儿园",:number=>"huolg",:template_id=>template.id,:note=>"这是幼儿园简介")
    kind.loading!
    puts "添加管理员"
    #添加管理员
    User.create(:login=>"huolg",:name=>"幼儿园管理员",:note=>"我是管理员",:tp=>2,:password=>"111111",:password_confirmation=>"111111",:kindergarten_id=>kind.id)
    puts "添加教职工"
    kind.reload
    #添加5个教职工
    (1..5).to_a.each do |i|
      user = User.new(:login=>"staff#{i}",:name=>"教职工#{i}",:note=>"我是教职工#{i}",:tp=>1,:password=>"111111",:password_confirmation=>"111111",:kindergarten_id=>kind.id)
      user.role = kind.roles.random
      user.staff = Staff.new(:card_code=>"1000#{i}")
      user.save
      print "."
    end
    puts "添加年级"
    #添加年级
    (1..3).to_a.each do |i|
      grade = Grade.new(:kindergarten_id=>kind.id,:name=>"#{i}年级",:note=>"这是#{i}年级",:staff_id=>kind.staffs.random.id)
      grade.save
      print "."
    end
    puts "添加班级"
    #添加班级
    (1..4).to_a.each do |i|
      squad = Squad.new(:name=>"班级#{i}",:note=>"这是班级#{i}",:grade_id=>kind.grades.random.id,:kindergarten_id=>kind.id,:historyreview=>"2013")
      squad.save
      print "."
    end
    puts "关联负责老师"
    #关联负责老师
    kind.squads.each do|squad|
      squad.teachers << Teacher.new(:staff_id=>kind.staffs.random.id)
      squad.save
      print "."
    end
    
    puts "添加学生"
    #添加6个学生
    (1..60).to_a.each do |i|
      user = User.create(:login=>"student#{i}",:name=>"学生#{i}",:note=>"我是学生#{i}",:tp=>0,:password=>"111111",:password_confirmation=>"111111",:kindergarten_id=>kind.id)
      StudentInfo.create!(:weixin_code=>"weixin_code#{i}",:card_code=>"1000#{i}",:birthday=>Time.now,:squad_id=>kind.squads.random.id,:user_id=>user.id,:kindergarten_id=>kind.id)
      print "."
    end
    puts "demo添加完毕."
  end
end