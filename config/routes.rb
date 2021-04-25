Rails.application.routes.draw do
  devise_for :users, defaults: {format: :json}, path: '', path_names: {
    sign_in: 'login',
    sign_out: 'logout',
    registration: 'signup'
  }, 
  controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }
  devise_scope :user do 
    post '/refresh_token' => 'users/sessions#refresh'
  end
  root 'businesses#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  use_doorkeeper do
    skip_controllers :authorizations, :applications, :authorized_applications
  end
  namespace :api do 
    namespace :v1 do 
      resources :provider_oauth_tokens, only: [:create]
      resources :irregular_events, only: [:update, :destroy]
      resources :regular_events, only: [:update, :destroy]
      resources :businesses do 
        resources :regular_events, only: [:index, :create]
        resources :irregular_events, only: [:index, :create]
      end
      resources :locations do
        resources :regular_events, only: [:index, :create]
        resources :irregular_events, only: [:index, :create]
        member do 
          get 'hours_summary', to: 'hours_summary#index'
        end
      end
      get '/me', to: 'current_user#index'
    end
  end 
end
