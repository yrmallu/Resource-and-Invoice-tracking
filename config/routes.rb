Hrms::Application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".
  resources :companies
  resources :accessrights do
    collection do
      get 'check_role_accessright'
    end  
  end
  
  resources :users do
     collection do
     	get 'get_user_accessright'
      	post 'update_user_accessright'
 	  	get 'user_filter'
 	  	post 'user'
		get 'forgot_password'
		get 'reset_password'
		post 'set_new_password'
		post 'email_for_password'
		get 'list_user_project_detail'
		get 'reporting'
		get 'dashboard'
      	get 'latest_invoice_raise'
      	get 'resource_track'
      	get 'total_billable_resource'
      	get 'allocated_resource'
      	get 'bench_resource'
      	get 'upload_emp_doc'
      	post 'save_emp_doc'
      	get 'experience_user_info'
      	get 'project_dashboard'
      	get 'project_detail'
      	get 'fc_allocated_resource'
      	get 'tm_allocated_resource'
      	get 'resource_search'
        get 'tm_project_detail'
	    get 'reporting_to'
		get 'home_page'
		get 'profile'
		get 'emp_code_validation'
     end
   end
   
  resources :departments 
  resources :user_histories
  resources :roles
  
  resources :timesheets do
  	 collection do
		 get 'add_timesheet'
		 get 'add_specific_timesheet'
		 get 'add_user_specific_timesheet'
		 get 'date_specific_timesheet'
		 post 'specific_timesheet'
		 get 'edit_task'
		 post 'update_task'
		 get 'new_task'
		 get 'archive_task'
		 get 'show_task'
		 post 'create_timesheet'
		 get 'get_user_project'
		 get 'check_timesheet_exist'
		 get 'get_task_list'
		 get 'get_logged_hours'
		 get 'get_monthly_timesheets'
	 end
  end
  
  resources :contact_points do
    collection do
      get 'email_validation'
    end
  end
  
  resources :clients do
    collection do
      get 'add_contact_point'
      get 'contact_detail'
    end
  end
  
  resources :projects do
    collection do
      get 'get_client_contact_point'
      get 'detele_project_file'
      get 'download_file'
      get 'fixed_cost_payment'
	  get 'time_material_milestone'
      post 'fc_payment_create'
      get 'delete_milestone'
	  get 'delete_tm_milestone'
      get 'time_material_payment'
      post 'tm_payment_create'
      get 'get_milestone'
	  get 'get_new_fc_milestone'
	  get 'get_new_tm_milestone'
	  get 'get_tm_milestone'
  	  get 'project_filter'
  	  post 'project'
      get 'delete_time_material'
	  get 'project_members'
	  post 'assign_project_members'
	  get 'project_module'
	  post 'project_module_create'
	  post 'tm_milestone_create'
	  get 'list_project_modules'
	  get 'edit_project_module'
	  post 'update_project_module'
	  delete 'archive_project_module'
	  get 'show_project_module'
      get 'fc_milestone'
	  get 'tm_milestone'
      get 'fc_raise_invoice'
	  get 'tm_raise_invoice'
      get 'get_fc_detail'
	  get 'get_tm_detail'
      post 'update_fc_milestone'
	  post 'update_tm_milestone'
      get 'invite_project_team'
      get 'resend_project_invitation'
      delete 'cancel_project_invitation'
	  delete 'cancel_invited_project_invitation'
    end
  end
  
  resources :sessions, only: [:new, :create, :destroy]
   match '/home',  to: 'contents#home',         via: 'get'
  match '/signin',  to: 'sessions#new',         via: 'get'
  match '/signout', to: 'sessions#destroy',     via: 'delete'
  match '/forgot_password', to: 'users#forgot_password',     via: 'get'
  match '/reset_password', to: 'users#reset_password',     via: 'get'
  match '/verify_project_invite', to: 'projects#verify_project_invite',     via: 'get'
  
  # You can have the root of your site routed with "root"
  root 'contents#home'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end
  
  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
