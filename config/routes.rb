Rails.application.routes.draw do
  devise_for :users
  api_version(:module => "api/v1/customer", :header => {:name => "Accept", :value => "application/centarium.com; version=1"}) do
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
        post :send_otp_mobile
        post :otp_change_mobile
        post :upload_doc
        post :forgot_password
        post :update_password
      end
    end    
    resources :stores do
      collection do
        post :store_detail
        post :add_fav
      end
    end
    resources :products do
      collection do
        post :product_list
        post :product_detail
        post :product_review
        post :write_review
        post :add_fav
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
        post :contact_us   
      end
    end
    resources :notifications do
      collection do
        post :notification_list
        post :delete_notification
      end
    end
    namespace :storeapi do
      resources :stores do
        collection do
          post :sign_up
          get :generate_code
          post :login
          post :verify_otp
          post :resend_otp
          post :logout
          get :view_profile
          post :update_profile
          post :send_otp_email
          post :otp_change_email
          post :upload_doc
          post :send_otp_mobile
          post :otp_change_mobile
          post :forgot_password
          post :update_password
        end
      end
      resources :products do
        collection do
          post :product_update
          post :product_detail
          post :product_list
          post :product_review
        end
      end
      resources :campaigns do
        collection do
          get :product_list_name
          post :edit_campaign
          post :list_campaign
          post :detail_campaign
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
        get :user_status
        get :user_approve
      end
    end
    resources :stores do
      collection do
        post :store_status
        get :store_approve
        post :import
        post :export
      end
    end
    resources :products do
     collection do
        post :product_status
      end
    end
    resources :static_pages
    resources :faqs    
    resources :contact_us
    resources :tokens
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
