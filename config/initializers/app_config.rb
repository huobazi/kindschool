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
  "61001"=>{
  "my_school/messages"=>['index',"show","edit","create","update"]
},
  "61002"=>{
  "my_school/notices"=>['new']
},
  "62003"=>{
  "my_school/notices"=>["index","show"]
},
  "63000"=>{
  "my_school/messages"=>["outbox","outbox_show"]
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
   "system"=>{
    "31000"=>{"my_school/templates"=>['set_default_template_view']},
    "32000"=>{"my_school/page_contents"=>['index','edit','new','show']},
    "34000"=>{
      "my_school/content_patterns"=>['index','edit']
    },
    "35000"=>{
      "my_school/smarties" => ['index','create']
    },
    "36000"=>{
      "my_school/roles"=>['index']
    }
   },
   "100000"=>{
    "101000" => {
      "my_school/growth_records" => ["home", "new", "edit", "show"],
   },
     "102000" => {
     "my_school/garden_growth_records" => ["garden", "new", "edit", "show"]
   }
   },
    "80000" => {
      "81000" =>{
        "my_school/albums" => ["index","new","show","edit"],
        "my_school/album_entries" => ["index","new","show","edit"]
      } 
    },
    "110000" => {
      "111000" => {
        "my_school/topics" => ["index", "new", "edit", "show"]
      }
    }


}

