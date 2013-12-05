ActiveAdmin.register AdminUser do
  #  controller.authorize_resource
  index do
    column :email
    column :role_name_label
    column :current_sign_in_at
    column :last_sign_in_at
    column :sign_in_count
    default_actions
  end

  filter :email

  form do |f|
    f.inputs "Admin Details" do
      f.input :email
      f.input :role_name, :as=>:select,:collection=>AdminUser::ROLE_NAME_DATA.invert, :required => true
      f.input :password
      f.input :password_confirmation
    end
    f.actions
  end

  show do
    attributes_table do
      row :email
      row :role_name_label
      row :current_sign_in_at
      row :last_sign_in_at
      row :sign_in_count
      row :created_at
      row :updated_at
    end
  end
end
