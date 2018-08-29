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



end
