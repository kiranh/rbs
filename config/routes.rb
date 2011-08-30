SocialCrm::Application.routes.draw do
  mount CommunityEngine::Engine => "/"
  resources :users do
    collection do
      post 'return_admin'      
      get 'complete_profile'
    end
    member do
      get 'getting_started'
      get 'dashboard'      
      get 'edit_account'
      get 'invite'
      get 'signup_completed'
      get 'activate'

      put 'toggle_moderator'
      put 'toggle_featured'

      put 'change_profile_photo'
      put 'update_account'
      put 'deactivate'

      get 'welcome_photo'
      get 'welcome_about'
      get 'welcome_invite'
      get 'welcome_complete'

      post 'assume'

      match 'statistics'
      match 'crop_profile_photo'
      match 'upload_profile_photo'
      match 'metro_area_update'
    end
    resources :short_messages
  end

  resources :contacts do
    collection do
      get :callback
    end
  end

  resources :look_for do
    match :auto_complete, :on => :collection
  end

  resources :messages do
      match :auto_complete_for_username, :on => :collection
      collection do
        post :delete_message_threads
        post :delete_selected
      end
  end
  
  resources :posts do
    collection do
      get :manage
    end
    match :send_to_friend, :on => :member
    match :update_views, :on => :member
    match :download_doc_file, :on => :member
    match :remove_doc, :on => :member
    match :remove_video, :on => :member
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
  resources :groups
  match 'groups/add_member/:id',          :to => 'groups#add_member', :as => 'add_group_member'
  match 'groups/accept_member/:group&:member',          :to => 'groups#accept_member', :as => 'accept_group_member'
  match 'groups/reject_member/:group&:member',          :to => 'groups#reject_member', :as => 'reject_group_member'
  match 'groups/make_moderator/:group&:member',         :to => 'groups#make_moderator',:as => 'make_moderator'
  match 'groups/remove_moderator/:group&:member',         :to => 'groups#remove_moderator',:as => 'remove_moderator'
  match 'groups/index/:id',               :to => 'groups#index',  :as => 'admin_group'
  match 'groups/leave/:id',               :to => 'groups#leave',  :as => 'leave_group'
  match 'groups/invite/:id',              :to => 'groups#invite', :as => 'invites'
  match 'groups/invite_friends/:id',      :to => 'groups#invite_friends', :as => 'invite_friends'
  match 'group/search',                  :to => 'groups#search', :as => 'search_group'
  match 'group/term_search',                  :to => 'groups#term_search', :as => 'group_search'


  match 'contacts/send_messages_to_connections',                  :to => 'contacts#send_messages_to_connections', :as => 'send_linked_in_message'

  scope "/:commentable_type/:commentable_id" do
    resources :comments
  end
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
  #    end

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
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
