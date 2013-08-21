School::Application.routes.draw do


  match 'code/code_image' => 'code#code_image'
  match 'code/recode' => 'code#recode'
  match 'my_school' => 'my_school/main#index'
  namespace :my_school do
    resources :teaching_plans
    resources :personal_sets
    resources :approve_modules do
      collection do
        get :get_edit_ids
      end
    end
    resources :approves do
      collection do
        get :news_list
        get :news_show
        post :one_news_approve
        get :activities_list
        get :activity_show
        get :notices_list
        get :notice_show
        get :messages_list
        get :message_show
        get :topics_list
        get :topic_show
        get :get_approve_record_log
      end
    end
    resources :comments do
      collection do
        post :send_comment
        post :modify
      end
      member do
        get :virtual_delete
      end
    end
    resources :news 
    resources :my_kindergarten do
    end
    resources :main do
      collection do
        get :no_kindergarten
        get :about
        get :contact_us
        get :feature
        get :show_official_about_us
        get :admissions_information
        get :show_one_new
        get :show_new_list
      end
    end
    resources :virtual_squads  do 
      collection {get :get_edit_ids}
    end
    resources :roles do
      member do
        get :set_operate_to_role
        post :save_operate_to_role 
      end
    end
    resources :smarties do
      collection {get :role_operates}  
    end
    resources :albums do
      collection {get :grade_class}
      member{get :entry_index}
      resources :album_entries do
        member {get :choose_main_img}
      end
    end
    resources :career_strategies do
      collection do
        delete :destroy_multiple
        get :career_class,:career_class_validate
      end
    end

    resources :interest_activities

    resources :content_patterns
    resources :seedlings do
      collection {get :grade_class}
      collection {get :class_student}
      collection {post :destory_choose}
      collection {delete :destroy_multiple}
    end
    resources :physical_records do
      collection do
        delete :destroy_multiple
      end
      collection {get :grade_class}
      collection {get :class_student}
    end
    resources :cook_books do
      collection do
        delete :destroy_multiple
      end
    end

    resources :statistics do
      get :virtual_squad, :message, :growth_record, :kind_stat, :on => :collection
    end
    resources :users do
      collection do
        get :login,:logout,:error_notice,:show,:change_password_view
        post :login,:change_password
      end
      member do
        get :set_send_sms,:set_gather_sms
        post :reset_password
      end
    end
    resources :activity_entries do
      member do
        get :virtual_delete
      end
    end
    resources :squads do
      collection do
        delete :destroy_multiple
        post :add_strategy
      end
      member do
        get :add_strategy_view
      end
    end
    resources :notices do
      collection do
        delete :destroy_multiple
        get :approve
      end
    end
    resources :messages do
      member do
        get :outbox_show
        get :draft_show
        get :draft_edit
        get :get_edit_ids
        get :get_entry_status
        post :draft_update
        post :return_message
      end
      collection do
        get :outbox,:get_kindergarten,:get_grade,:get_student
        post :get_grades_all,:get_squads_all,:get_roles_all,:get_users_all
        delete :destroy_multiple
        get :draft_box
      end
    end
    resources :home do
      collection do
        get :about,:contact_us
      end
    end
    resources :grades do
      collection do
        delete :destroy_multiple
      end
    end
    resources :staffs do
      collection do
        delete :destroy_multiple
      end
    end
    resources :page_contents do
      member do
        get :delete_content,:edit_content
        post :add_content,:update_content
      end
    end
    resources :student_infos do
      collection do
        delete :destroy_multiple
        get :grade_squad_partial
        get :student_execl
        post :download
        get :download_student_infos
        get :virtual_squad 
        post :virtual_squad_choose
        post :import
        get :delete
      end
    end
    resources :templates do
      collection do
        get :set_default_template_view
        get :set_default_template
      end
    end

    resources :teachers do
      collection do
        get :allocation
        post :update_allocation
        get :set_class_teacher
        get :set_class_teacher_for_squad_view
        get :set_class_teacher_for_squad
        get :cancel_class_teacher
      end
    end

    resources :growth_records do
      collection do
        get :home
        delete :destroy_multiple
        get :grade_squad_partial
        get :squad_student_partial
      end
      member do
        get :delete_img
      end
    end

    resources :topic_categories do
      collection do
        delete :destroy_multiple
      end
    end

    resources :garden_growth_records do
      collection do
        get :garden
        delete :destroy_multiple
      end
      member do
        get :delete_img
      end
    end

    resources :topics do
      collection do
        delete :destroy_multiple
        get :my
        get :grade_squad_partial
      end
    end
    resources :topic_entries do
      member do
        get :virtual_delete
      end
    end
    resources :activities do
      collection do
        delete :destroy_multiple
        get :grade_squad_partial
      end
    end
  end

  match 'weixin' => 'weixin/main#index'
  match 'weixin/about' => 'weixin/main#about'
  match 'weixin/contact_us' => 'weixin/main#contact_us'
  namespace :weixin do
    resources :api do
      collection do
        post :index
        get :index
      end
    end
    resources :main do
      collection do
        get :bind_user,:error_messages,:get_user_all_teachers,:get_user_all_squads,:weiyi_error_messages
        post :bind_user
        get :bind_weiyi
        post :bind_weiyi
      end
    end
    resources :users do
      collection do
        get :login,:error_messages
        post :login
      end
    end
    resources :cook_books
    resources :albums
    resources :topics do
      collection do
        get :my
        get :grade_squad_partial
      end
    end
    resources :growth_records do
      collection do
        get :grade_squad
        get :squad_student
      end
      member do
        get :delete_img
      end
    end
    resources :garden_growth_records do
      collection do
        get :grade_squad
        get :squad_student
      end
      member do
        get :delete_img
      end
    end
    resources :activities do
      collection do
        get :grade_squad_partial
      end
    end
    resources :interest_activities do
      collection do
        get :grade_squad_partial
      end
    end
    resources :activity_entries
    resources :topic_entries
    resources :messages do
      member do
        get :outbox_show
        get :draft_show
        get :draft_edit
        get :get_edit_ids
        post :draft_update
        post :return_message
      end
      collection do
        get :outbox,:get_kindergarten,:get_grade,:get_student
        post :get_grades_all,:get_squads_all,:get_roles_all,:get_users_all
        delete :destroy_multiple
        get :draft_box
      end
    end
    resources :notices
    resources :weixin_share_users
  end

  namespace :weixin do
    resources :api
  end

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => 'main#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
end
