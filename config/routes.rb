Rails.application.routes.draw do
  resources :users
  resources :responses
  resources :tasks
  resources :class_groups
  root to: 'home#index'
  get "home", to: 'home#index'
  get "login", to: 'login#index'
  get "turmas", to: 'class_groups#index'
  #get "tarefas", to: 'tasks#index'

  get "vincular", to: 'person#index'
  get "respostas", to: 'responses#index'
end
