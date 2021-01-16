Rails.application.routes.draw do
  use_doorkeeper
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }
  resources :businesses
  root 'businesses#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  use_doorkeeper do
    skip_controllers :authorizations, :applications, :authorized_applications
  end
end
