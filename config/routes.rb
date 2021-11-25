Rails.application.routes.draw do
  root to: "bakes#index"
  devise_for :users, path_prefix: 'my', controllers: {
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
    get '/users/:id/edit', to: 'users/registrations#edit', as: 'edit_user_reg'
    put '/users/:id', to: 'users/registrations#update'
    get '/users', to: 'users/registrations#index'
    delete '/users/:id', to: 'users/registrations#destroy'
  end
  get '/mybakes', to: 'bakes#my_bakes', as: 'my_bakes'
  delete '/bakes_image/:id', to: 'bakes#purge_image', as: 'bakes_image_purge'
  get '/admin', to: 'admin#admin'
  resources :bakes
  resources :categories
  get '/cart', to: 'bake_orders#cart'
  post '/cart', to: 'bake_orders#update_cart'
  put '/cart', to: 'bake_orders#update_cart'
  delete '/cart', to: 'bake_orders#empty_cart'
  post '/checkout', to: 'bake_orders#checkout'
  get '/myorders', to: 'bake_orders#my_bake_orders'
  get '/users/:user_id/orders', to: 'bake_orders#users_bake_orders', as: 'users_bake_orders'
  get '/users/:user_id/cart', to: 'bake_orders#users_cart', as: 'users_cart'
  resources :bake_orders, path: 'orders'
  get '/mybakejobs', to: 'bake_jobs#my_bake_jobs', as: 'my_bake_jobs'
  get '/users/:user_id/bake_jobs', to: 'bake_jobs#users_bake_jobs', as: 'users_bake_jobs'
  resources :bake_jobs, path: 'bakejobs'
  get '/*page', to: 'bakes#index', page: /(?!bakes|categories|users|orders|admin|rails).*/  

end
