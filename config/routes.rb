Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }
  resources :teams
  resources :users do
    member do
      get 'edit_password_by_admin'
      get 'show_versions'
      get 'otp_verification'
      patch 'update_password_by_admin'
      post 'verify_otp'
      post 'block'
      post 'unblock'
    end
  end

  resources :rounds do
    member do
      post :summarize_round
    end

    resources :matches, except: %i[index show] do
      resources :bets, except: %i[index show]
    end
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root 'home#show'
end
