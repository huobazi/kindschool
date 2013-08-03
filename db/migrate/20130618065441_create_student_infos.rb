#encoding:utf-8
class CreateStudentInfos < ActiveRecord::Migration
  def change
    create_table :student_infos do |t|
      t.integer :user_id #账号
      t.integer :squad_id #班级
      t.integer :grade_id #年级
      t.integer :kindergarten_id #幼儿园
      t.datetime :birthday  #出生日期
      t.datetime :come_in_at #入园时间
      t.integer :card_category, :default =>0 #证件类别，居民身份证、护照、无证件
      t.string :card_code  #证件号
      t.string :guardian #监护人名字
      t.integer :guardian_card_category, :default =>0 #监护人证件类别，居民身份证、护照、无证件
      t.string :guardian_card_code  #监护人证件号
      t.string :nationality #国籍
      t.string :nation #民族
      t.integer :overseas_chinese, :default =>0 #港澳台侨，非港澳台侨、归侨、华侨、侨眷、香港同胞、台湾同胞、外籍华裔人、非华裔中国人、外国人、澳门同胞、其他
      t.integer :household , :default =>1#户口性质，农业户口、非农业户口
      t.string :birthplace  #出生地
      t.string :native    #籍贯
      t.string :domicile_place  #户口所在地
      t.string :family_address  #家庭地址
      t.boolean :leftover_children, :default => false  #是否留守儿童
      t.boolean :employofficialt, :default => false    #是否进城务工人员子女
      t.boolean :insured, :default => false            #是否低保
      t.boolean :subsidize, :default => false          #是否接受资助
      t.boolean :deformity, :default => false          #是否残疾儿童
      t.string :deformity_category                     #残疾儿童类型
      t.boolean :lodging, :default => false            #是否寄宿生
      t.boolean :orphan, :default => false             #是否孤儿
      t.integer :housing, :default =>0                 #住房性质,购房、自建房、购二手房、合法租房、单位宿舍、租房、集体宿舍、集资建房、私建房、购合法商品房、福利房、购合法集资房、其他
      t.integer :live_family, :default =>0             #居住情况，幼儿随父母居住、幼儿随亲戚居住、幼儿随其他人员居住
      t.boolean :only_child, :default => false         #是否独生子女
      t.integer :brothers,:default =>1  #家中子女数
      t.integer :children_number,:default =>1 #本人第几胎
      t.string :family_ties        #关系
      t.string :family_name        #姓名
      t.string :politics_status    #政治面貌
      t.datetime :family_birthday  #出生日期
      t.string :profession         #职业
      t.string :duties             #职务
      t.string :working            #工作单位
      t.string :family_register    #户籍类型
      t.string :family_phone       #移动电话
      t.string :family_email       #电子邮箱
      t.string :living_time        #父母在深连续居住时间
      t.string :family_marital     #婚姻状况
      t.string :education          #学历
      t.string :safe_box           #社会保险箱
      t.string :head_url           #头像
      t.timestamp :deleted_at
      t.timestamps
    end
  end
end
