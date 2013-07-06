School::Application.routes.draw do

  match 'my_school' => 'my_school/main#index'
  match 'my_school/no_kindergarten' => 'my_school/main#no_kindergarten'
  match 'my_school/about' => 'my_school/main#about'
  match 'my_school/contact_us' => 'my_school/main#contact_us'
  namespace :my_school do
    resources :seedlings
    resources :users do
      collection do
        get :login,:logout,:error_notice
        post :login
      end
      collection do
        get :change_password_view
        post :change_password
      end
    end
    resources :squads
    resources :notices
    resources :messages do
      collection do
        get :get_kindergarten,:get_grade,:get_student
      end
    end
    resources :home do
      collection do
        get :about,:contact_us
      end
    end
    resources :grades
    resources :staffs
    resources :page_contents do
      member do
        get :delete_content,:edit_content
        post :add_content,:update_content
      end
    end
    resources :student_infos
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
      end
    end
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
