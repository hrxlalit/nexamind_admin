Rails.application.routes.draw do
  devise_for :users

  namespace :api, defaults: { format: :json } do
    scope module: :v1 do

      resources :users do
        collection do
          post :sign_up
          get :generate_code
          post :login
          post :verify_otp
          post :resend_otp
          post :logout
          get :view_profile
          post :update_profile
          post :otp_change_mobile
        end
      end

      resources :socials do
        collection do
          post :social_login
        end
      end

      resources :static_contents  do
        collection do
          post :static_content    
        end
      end

    end
  end

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
    resources :stores do
      collection do
        post :store_status
      end
    end
    resources :products
    resources :static_pages
    resources :faqs    
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
