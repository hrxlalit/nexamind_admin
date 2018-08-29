Rails.application.routes.draw do
  devise_for :users

  namespace :api, defaults: { format: :json } do
    scope module: :v1 do

      resources :users do
        collection do
          post :sign_up
          get :generate_code
          post :login
          post :update_profile
        end
      end

    end
  end



end
