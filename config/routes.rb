Rails.application.routes.draw do
  root to: "libraries#index"

  resources :users
  resources :libraries do
    member do
      get :activity
      get :info
    end

    resources :assets do
      resources :comments

      collection do
        get :delete
        delete :delete
      end

      member do
        get :activity
      end
    end
  end
end
