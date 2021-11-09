Rails.application.routes.draw do
  devise_scope :user do
    get '/login', to: 'devise/sessions#new'
    get '/logout', to: 'devise/sessions#destroy'
    get '/signup', to: 'devise/registrations#new'
    get '/myaccount', to: 'devise/registrations#edit'
    get '/upgrade', to: 'users/registrations#upgrade_user', as: 'upgrade_user'
    post '/upgrade', to: 'users/registrations#upgrade_user_to_baker', as: 'upgrade_user_to_baker'
  end
  devise_for :users, controllers: {
    sessions: 'users/sessions'
  }
  get '/mybakes', to: 'bakes#mybakes'
  root to: "bakes#index"
  resources :bakes
end
