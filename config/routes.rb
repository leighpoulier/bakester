Rails.application.routes.draw do
  devise_scope :user do
    get '/login', to: 'devise/sessions#new'
    get '/logout', to: 'devise/sessions#destroy'
    get '/signup', to: 'devise/registrations#new'
  end
  devise_for :users
  root to: "bakes#index"
  resources :bakes
end
