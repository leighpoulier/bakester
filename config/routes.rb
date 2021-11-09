Rails.application.routes.draw do
  devise_for :users
  root to: "bakes#index"
  resources :bakes
end
