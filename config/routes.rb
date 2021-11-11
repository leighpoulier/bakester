Rails.application.routes.draw do
  root to: "bakes#index"
  devise_for :users, controllers: {
    sessions: 'users/sessions'
  }
  devise_scope :user do
    get '/login', to: 'devise/sessions#new'
    get '/logout', to: 'devise/sessions#destroy'
    get '/signup', to: 'devise/registrations#new'
    get '/myaccount', to: 'devise/registrations#edit'
    get '/changepassword', to: 'users/registrations#edit_password', as: 'change_password'
    get '/upgrade', to: 'users/registrations#upgrade', as: 'upgrade_user'
    post '/upgrade', to: 'users/registrations#upgrade_to_baker', as: 'upgrade_user_to_baker'
    get '/users/:id', to: 'users/registrations#show', as: 'user'
    get '/users', to: 'users/registrations#index'
  end
  get '/mybakes', to: 'bakes#my_bakes', as: 'my_bakes'
  delete '/bakes_image/:id', to: 'bakes#purge_image', as: 'bakes_image_purge'
  get '/admin', to: 'admin#admin'
  resources :bakes
  resources :categories
  
  get '/*page', to: 'bakes#index', page: /(?!bakes|categories|users|admin|rails).*/  

end
