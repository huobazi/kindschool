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
  "my_school/messages"=>['index',"show","create"]
},
  "61002"=>{
  "my_school/notices"=>['new']
},
  "62003"=>{
  "my_school/notices"=>["index","show"]
},
  "63000"=>{
  "my_school/messages"=>["outbox","outbox_show", "edit", "update"]
 },
   "64000"=>{
  "my_school/messages"=>["draft_box", "draft_show", "draft_edit"]
 }
},
  "personnel"=>{
  "11000"=>{
  "my_school/grades"=>["index","new", "show", "edit"]
}, "12000"=>{
  "my_school/squads" => ["index", "new", "show", "edit", "add_strategy_view"]
}, "13000" => {

  "my_school/staffs" => ["index", "new", "show", "edit"]},
  "14000" => {
  "my_school/student_infos" => ["index", "new", "show", "edit"]},
  "15000" => {"my_school/virtual_squads"=>['index','new','edit','show']}
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
      "my_school/roles"=>['index','show','edit','new','set_operate_to_role']
    },
    "37000"=>{
      "my_school/career_strategies"=>['index','show','edit','new']
    },
    "38000"=>{
      "my_school/topic_categories"=>["index", "show", "edit", "new"]
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
    },
    "120000" => {
      "121000" => {
        "my_school/activities" => ["index", "new", "edit", "show"]
      },
      "122000"=>{
        "my_school/interest_activities" => ["index", "new", "edit", "show"]
      }
    }


}
