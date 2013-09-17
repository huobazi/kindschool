#encoding:utf-8
# 创建短信配置文件
SMS_CONFIG = YAML.load_file("config/sms.yml")[::Rails.env]
# 创建平台配置文件
WEBSITE_CONFIG = YAML.load_file("config/site_config/website.yml")[::Rails.env]
#学生前缀名
PRE_STUDENT = "wys"
WEIYI_MENU = {"index"=>"关于我们","weiyi_solution"=>"解决方案","weiyi_interact"=>"家园互动","weiyi_contact"=>"联系我们"}
#模板信息
PAGE_CONTENTS = YAML.load_file("config/site_config/page_contents.yml")
#默认action，可以快速使用，配置菜单功能
DEFULT_ACTION = ['index','show','edit','new','update','create','destroy']
#富文本框的item选择
ITEMKE=['justifyleft', 'justifycenter', 'justifyright','justifyfull', 'insertorderedlist', 'insertunorderedlist', 'indent', 'outdent', '|','formatblock', 'fontname', 'fontsize', '|', 'forecolor', 'hilitecolor', 'bold',
        'italic', 'underline', 'strikethrough', 'lineheight', 'removeformat'] 
ITEMS=[
        'source', '|', 'undo', 'redo', '|', 'preview', 'print', 'template', 'code', 'cut', 'copy', 'paste',
        'plainpaste', 'wordpaste', '|', 'justifyleft', 'justifycenter', 'justifyright',
        'justifyfull', 'insertorderedlist', 'insertunorderedlist', 'indent', 'outdent', 'subscript',
        'superscript', 'clearhtml', 'quickformat', 'selectall', '|', 'fullscreen', '/',
        'formatblock', 'fontname', 'fontsize', '|', 'forecolor', 'hilitecolor', 'bold',
        'italic', 'underline', 'strikethrough', 'lineheight', 'removeformat', '|', 'image', 'multiimage',
        'flash', 'media', 'insertfile', 'table', 'hr', 'emoticons', 'baidumap', 'pagebreak',
        'anchor', 'link', 'unlink', '|', 'about'
]

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
  "my_school/notices"=>['new', 'edit']
},
  "62003"=>{
  "my_school/notices"=>["index","show"]
},
  "63000"=>{
  "my_school/messages"=>["outbox","outbox_show", "edit", "update"]
 },
   "64000"=>{
  "my_school/messages"=>["draft_box", "draft_show", "draft_edit"]
 },
   "65000"=>{
    "my_school/news"=>DEFULT_ACTION
   }
},
  "personnel"=>{
  "11000"=>{
  "my_school/grades"=>DEFULT_ACTION
}, "12000"=>{
  "my_school/squads" => ["index", "new","create","update", "show", "edit"],
  "my_school/teachers" => ["set_class_teacher_for_squad_view"]
}, "13000" => {
  "my_school/staffs" => ["index", "new", "show", "edit", "create", "update"],
  "my_school/teachers" => ["allocation"]
  },
  "14000" => {
  "my_school/student_infos" => ["index", "new", "show", "edit", "create", "update"]},
  "15000" => {"my_school/virtual_squads"=>['index','new','edit','show',"create","update"]},
  "16000" => {"my_school/users"=>['edit','update','show',"change_password","change_password_view"]}
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
    "32000"=>{"my_school/page_contents"=>['index','edit','new','show','edit_content']},
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
      "my_school/career_strategies"=>DEFULT_ACTION
    },
    "38000"=>{
      "my_school/topic_categories"=>["index", "show", "edit", "new"]
    },
    "39000"=>{
      "my_school/my_kindergarten"=>["index",  "edit", "update"]
    },
    "39100"=>{
      "my_school/approve_modules"=>["index","edit"]
    }

   },
   "100000"=>{
    "101000" => {
      "my_school/growth_records" => ["home", "new", "edit", "show"],
   },
     "102000" => {
     "my_school/garden_growth_records" => ["garden", "new", "edit", "show"]
   },
     "103000" => {
      "my_school/teaching_plans" => DEFULT_ACTION
     }
   },
    "80000" => {
      "81000" =>{
        "my_school/albums" => ["index","new","show","edit","entry_index"],
        "my_school/album_entries" => ["index","new","show","edit"]
      },
      "82000" => {
        "my_school/personal_sets" => DEFULT_ACTION
      }
    },
    "70000" => {
      "71000" => {
        "my_school/topics" => ["index", "new", "edit", "show","create","update"],
        "my_school/topic_entries" => ["edit"]
      },
      "72000" => {
        "my_school/topics" => ["my"]
      }
    },
    "statistics" => {
      "41000" => {
        "my_school/statistics" => ["growth_record"]
      },
      "43000" => {
        "my_school/statistics" => ["message"]
      },
      "42000" => {
        "my_school/statistics" => ["kind_stat"]
      },
      "44000" => {
        "my_school/statistics" => ["virtual_squad"]
      },
      "45000" => {
        "my_school/statistics" => ["sms_statistics","sms_all_statistics"]
      }
    },
    "120000" => {
      "121000" => {
        "my_school/activities" => ["index", "new", "edit", "show"],
        "my_school/activity_entries" => ["edit"]
      },
      "122000"=>{
        "my_school/interest_activities" => ["index", "new", "edit", "show"]
      }
    },
    "130000"=>{
      "131000" => {
        "my_school/approves" => ["news_list","news_show"]}
    }



}
