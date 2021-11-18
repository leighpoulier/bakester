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
  get '/mybakes/(:filter)', to: 'bakes#my_bakes', as: 'my_bakes', constraints: {filter: /[a-z_]*/}
  delete '/bakes_image/:id', to: 'bakes#purge_image', as: 'bakes_image_purge'
  get '/admin', to: 'admin#admin'
  # get '/bakes/(:filter)', to: 'bakes#index', as: 'bakes', constraints: {filter: /[a-z_]*/}
  resources :bakes
  resources :categories
  get '/cart', to: 'bake_orders#cart'
  # post '/addtocart', to: 'bake_orders#add_to_cart'
  post '/cart', to: 'bake_orders#update_cart'
  put '/cart', to: 'bake_orders#update_cart'
  delete '/cart', to: 'bake_orders#empty_cart'
  post '/checkout', to: 'bake_orders#checkout'
  get '/myorders', to: 'bake_orders#my_bake_orders'
  # get '/orders/(:filter)', to: 'bake_orders#index', as: 'orders', constraints: {filter: /[a-z_]*/}
  resources :bake_orders, path: 'orders'
  get '/mybakejobs', to: 'bake_jobs#my_bake_jobs', as: 'my_bake_jobs'
  # get '/bake_jobs/(:filter)', to: 'bake_jobs#index', as: 'bake_jobs', constraints: {filter: /[a-z_]*/}
  resources :bake_jobs, path: 'bakejobs'
  get '/*page', to: 'bakes#index', page: /(?!bakes|categories|users|orders|admin|rails).*/  

end
