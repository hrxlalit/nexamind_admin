Rails.application.routes.draw do
  devise_for :users

  namespace :api, defaults: { format: :json } do
    scope module: :v1 do

      resources :users do
        collection do
          post :sign_up
        end
      end

    end
  end



end
