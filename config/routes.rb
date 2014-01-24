School::Application.routes.draw do

  root :to => 'main#index'
  match 'code/code_image' => 'code#code_image'
  match 'code/recode' => 'code#recode'
  match 'my_school' => 'my_school/main#index'
  match "my_school/evaluate/:id/:basename.:extension", :controller => "my_school/evaluate_vtocs", :action => "download", :conditions => { :method => :get }
  namespace :my_school do
    resources :wonderful_episodes
    resources :credit_shop do
      get :products, :on => :collection
      get :show_product, :on => :member
      get :show_merchant, :on => :member
      get :add_to_cart, :on => :collection
      get :delete_to_cart, :on => :collection
      get :display_cart, :on => :collection
      get :empty_cart, :on => :collection
      get :checkout, :on => :collection
      post :save_order, :on => :collection
      get :ship, :on => :collection
      post :ship, :on => :collection
      get :user_center,:on => :collection
      get :show_product_categories,:on => :collection
      get :my_order, :on => :collection
      get :credit_activity, :on => :collection
      get :get_credit, :on => :collection
    end
    resources :eggs do
      get :get_egg,:on=>:collection
      get :prizes,:on=>:collection
      get :get_prize,:on=>:member
    end
    resources :reports do
      get :create, :on => :collection
    end
    resources :evaluate_vtocs do
      post :create_evaluate_asset, :on => :collection
      delete :delete_evaluate_asset, :on => :member
    end
    resources :evaluate_templates
    resources :evaluates do
      resources :evaluate_entries
      get :download_packages, :download, :on => :collection
    end
    resources :dean_emails
    resources :read_users do
      get :load_read_users, :on => :collection
    end
    resources :teaching_plans
    resources :personal_sets
    resources :approve_modules do
      get :get_edit_ids, :on => :collection
    end
    resources :approves do
      get  :news_list, :news_show, :activities_list, :activity_show, :notices_list,
           :notice_show, :messages_list, :message_show, :topics_list,
           :topic_show, :get_approve_record_log, :on => :collection
      post :one_news_approve, :on => :collection
    end
    resources :comments do
      post :send_comment, :on => :collection
      post :modify, :on => :collection
      get :virtual_delete, :on => :member
    end
    resources :news  do
      post :add_new_imgs, :on => :collection
      get :page_img_destroy, :on => :member
    end
    resources :my_kindergarten
    resources :main do
      get :no_kindergarten, :about, :contact_us, :feature, :show_official_about_us,
          :admissions_information, :show_one_new, :show_new_list, :dean_email,
          :dean_email_list, :dean_email_show,:show_cookbooks, :show_wonderful_episodes, :show_policies, :on => :collection
      post :dean_email, :create_dean_email, :on => :collection
    end
    resources :virtual_squads  do
      get :get_edit_ids, :on => :collection
    end
    resources :roles do
      get :set_operate_to_role, :on => :member
      post :save_operate_to_role, :on => :member
    end
    resources :smarties do
      collection {get :role_operates}
    end
    resources :albums do
      get :grade_class, :graduate_class, :on => :collection
      post :add_entry_imgs, :on => :collection
      get :entry_index, :on => :member
      resources :album_entries do
        get :choose_main_img, :on => :member
      end
    end
    resources :career_strategies do
      delete :destroy_multiple, :on => :collection
      get :career_class,:career_class_validate, :on => :collection
    end

    resources :interest_activities

    resources :content_patterns
    resources :seedlings do
      get :grade_class, :class_student, :on => :collection
      post :destory_choose, :on => :collection
    end
    resources :physical_records do
      get :grade_class, :class_student, :on => :collection
    end
    resources :cook_books

    resources :statistics do
      get :sms_all_statistics,:sms_statistics,:virtual_squad,
          :message, :growth_record, :teacher_stat, :kind_stat,
          :albums_stat, :on => :collection
    end
    resources :users do
      get :login,:logout, :error_notice, :show, 
          :change_password_view, :old_password_validator, :on => :collection
      post :login,:change_password, :on => :collection
      get :set_send_sms, :set_gather_sms, :on => :member
      post :reset_password, :on => :member
    end
    resources :activity_entries do
      get :virtual_delete, :on => :member
    end
    resources :squads do
      post :add_strategy, :on => :collection
      get :name_uniqueness_validator, :on => :collection
      get :add_strategy_view, :set_squads_teacher, :cancel_class_teacher, :on => :member
      get :set_squads_teacher
      get :cancel_class_teacher
    end
    resources :notices do
      delete :destroy_multiple, :on => :collection
      get :approve, :on => :collection
    end
    resources :messages do
      get :outbox_show, :draft_show, :draft_edit, :get_edit_ids,
          :get_entry_status, :on => :member
      post :draft_update, :return_message, :on => :member
      get :outbox, :get_kindergarten, :get_grade, :get_student, :draft_box, :on => :collection
      post :get_grades_all, :get_squads_all, :get_roles_all, :get_users_all, :on => :collection
      delete :destroy_multiple, :on => :collection
    end
    resources :home do
      get :show_videos, :about, :contact_us, :help_videos, :on => :collection
    end
    resources :grades do
      delete :destroy_multiple, :on => :collection
    end
    resources :staffs do
      get :phone_uniqueness_validator, :login_uniqueness_validator, :on => :collection
    end
    resources :page_contents do
      get :delete_content, :edit_content, :on => :member
      post :add_content, :update_content, :on => :member
    end
    resources :student_infos do
      delete :destroy_multiple, :on => :collection
      get :grade_squad_partial, :student_execl, :download_nanshan, :download_student_infos,
          :virtual_squad, :delete, :phone_uniqueness_validator, :on => :collection
      post :download, :virtual_squad_choose, :import, :on => :collection
    end
    resources :templates do
      get :set_default_template_view, :set_default_template, :on => :collection
    end

    resources :teachers do
      get :allocation, :set_class_teacher, :set_class_teacher_for_squad_view,
          :set_class_teacher_for_squad, :cancel_class_teacher, :on => :collection
      post :update_allocation, :on => :collection
    end

    resources :growth_records do
      get :home, :grade_squad_partial, :squad_student_partial, :on => :collection
      get :delete_img, :on => :member
    end

    resources :topic_categories

    resources :garden_growth_records do
      get :garden, :on => :collection
      get :delete_img, :on => :member
    end

    resources :topics do
      get :my, :grade_squad_partial, :on => :collection
    end
    resources :topic_entries do
      get :virtual_delete, :goodback, :on => :member
    end
    resources :activities do
      get :grade_squad_partial, :on => :collection
    end
  end

  match 'weixin' => 'weixin/main#index'
  match 'weixin/about' => 'weixin/main#about'
  match 'weixin/contact_us' => 'weixin/main#contact_us'
  namespace :weixin do
    resources :wonderful_episodes
    resources :api do
      post :index, :on => :collection
      get :index, :on => :collection
    end
    resources :main do
      get :bind_user, :error_messages, :get_user_all_teachers,
          :get_user_all_squads, :weiyi_error_messages, :bind_weiyi, :on => :collection
      post :bind_user, :bind_weiyi,  :on => :collection
    end
    resources :users do
      get :login, :error_messages, :change_password_view, :edit, :on => :collection
      post :login, :change_password, :update_user, :on => :collection
    end
    resources :cook_books
    resources :albums
    resources :topics do
      get :my, :grade_squad_partial, :on => :collection
    end
    resources :growth_records do
      get :grade_squad, :squad_student, :on => :collection
      get :delete_img, :on => :member
    end
    resources :garden_growth_records do
      get :grade_squad, :squad_student, :on => :collection
      get :delete_img, :on => :member
    end
    resources :activities do
      get :grade_squad_partial, :on => :collection
    end
    resources :interest_activities do
      get :grade_squad_partial, :on => :collection
    end
    resources :activity_entries
    resources :topic_entries
    resources :messages do
      get :outbox_show, :draft_show, :draft_edit, :get_edit_ids, :on => :member
      post :draft_update, :return_message, :on => :member
      get :outbox, :get_kindergarten, :get_grade, :get_student, :draft_box, :on => :collection
      post :get_grades_all, :get_squads_all, :get_roles_all, :get_users_all, :on => :collection
      delete :destroy_multiple, :on => :collection
    end
    resources :notices
    resources :weixin_share_users
    resources :news
    resources :personal_sets
    resources :teaching_plans
  end

  namespace :weixin do
    resources :api
  end

  match 'garden' => 'garden/main#index'
  namespace :garden do
    resources :garden_news
    resources :garden_pictures
    resources :garden_activities
    resources :classic_users
    resources :help do
      get :show_videos, :on => :collection
    end
  end
  resources :main do
    get :weiyi_tourism, :weiyi_solution, :weiyi_interact, :weiyi_contact,
        :weiyi_video, :weiyi_scheme, :weiyi_cultivate, :weiyi_benefit, :on => :collection
  end

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
end
