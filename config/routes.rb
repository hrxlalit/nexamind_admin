Rails.application.routes.draw do
  # devise_for :admin_users
  # devise_for :users
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  namespace :admin do
    root :to => "home#index"
    resources :sessions
    resources :home do
      collection do
        get :forget_password
        patch :reset_password
      end
    end
    resources :admin_users do
      collection do
        post :user_status
      end
      member do
        get :change_password
        post :update_password
      end
    end
    resources :users do
      collection do
        post :user_status
      end
    end
    resources :static_pages
    # resources :reports do
    #   collection do
    #     post :post_status
    #   end
    # end
    resources :block_users
    resources :faqs
    # resources :avatars do
    #   member do
    #     get :get_skin_color
    #     get :get_hair_color
    #     get :get_hair_style
    #     get :get_beard_shape
    #     get :get_beard_color
    #     get :get_spects
    #     get :get_hat
    #     get :get_cloths
    #   end
    #   collection do
    #     post :upload_categories
    #     post :add_avatar_images
    #     post :destroy_avatar_images
    #   end
    # end
    resources :feedbacks
    resources :report_users
    get '/login' => 'sessions#new'
  end
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
