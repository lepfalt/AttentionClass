Rails.application.routes.draw do
  resources :responses
  resources :tasks
  resources :class_groups
  root to: 'home#index'
  get "home", to: 'home#index'
  get "login", to: 'login#index'
  get "turmas", to: 'class_groups#index'
end
