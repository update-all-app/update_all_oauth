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
      resources :businesses
      resources :locations
      get '/me', to: 'current_user#index'
    end
  end 
end
