# 创建短信配置文件
SMS_CONFIG = YAML.load_file("config/sms.yml")[::Rails.env]
# 创建平台配置文件
WEBSITE_CONFIG = YAML.load_file("config/site_config/website.yml")[::Rails.env]

#模板信息
PAGE_CONTENTS = YAML.load_file("config/site_config/page_contents.yml")

MENUS ={"home"=>{
  "home"=>{
  "my_school/home"=>["index"]
}
},
  "60000" => {
  "61000"=>{
  "my_school/messages"=>["new"]
},
  "61002"=>{
  "my_school/notices"=>['new']
},
  "62003"=>{
  "my_school/notices"=>["index","show"]
}
},
  "personnel"=>{
  "11000"=>{
  "my_school/grades"=>["index","new", "show", "edit"]
}, "12000"=>{
  "my_school/squads" => ["index", "new", "show", "edit"]
}, "13000" => {

  "my_school/staffs" => ["index", "new", "show", "edit"]},
  "14000" => {
  "my_school/student_infos" => ["index", "new", "show", "edit"]}
},
   "90000"=>{
   "91000"=>{
    "my_school/seedlings"=>['index','new','edit','show']
    },
   "92000"=>{
    "my_school/physical_records"=>['index','new','edit','show']
   },
   "93000"=>{
    "my_school/cook_books"=>['index','new','edit','show']
   }
   },
   "30000"=>{
    "31000"=>{},
    "32000"=>{},
    "33000"=>{},
    "34000"=>{
      "my_school/content_patterns"=>['index','edit']
    }

   }


}

