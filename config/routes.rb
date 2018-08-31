Rails.application.routes.draw do
  devise_for :users

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      namespace :customer do
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
          end
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
