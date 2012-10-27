Relicious::Application.routes.draw do
  resources :meetups do
    collection do
      post ":id/invite" => "meetups#invite", :as => :invite
      get  ":id/join"   => "meetups#join",   :as => :join
      post ":id/status" => "meetups#status", :as => :status
    end
    resources :meetup_comments
  end

  resources :users do
    resources :reviews, :controller => :user_reviews

    post   "avails"     => "user_avails#create"
    put    "avails/:id" => "user_avails#update"
    delete "avails/:id" => "user_avails#destroy"

    post   "languages"     => "user_languages#create"
    delete "languages/:id" => "user_languages#destroy"

    get "meetups"         => "users#meetups"
    get "meetups/:status" => "users#meetups"
  end

  get "top/index"

  match "/auth/:provider/callback" => "sessions#callback"
  match "/logout" => "sessions#destroy", :as => :logout

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
  root :to => 'top#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
