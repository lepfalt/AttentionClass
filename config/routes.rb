Rails.application.routes.draw do
  resources :responses
  resources :tasks
  resources :class_groups
  get "login", to: "login#index"
end
