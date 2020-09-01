Rails.application.routes.draw do
  resources :users, only: %i[create show]
  get '/signup', to: 'users#new'
  get '/login', to: 'sessions#new'
  post '/sessions', to: 'sessions#create'
  delete '/sessions', to: 'sessions#destroy'

  root to: 'sessions#new'

  resources :responses
  resources :tasks
  get 'tarefa/respostas/:id', to: 'tasks#index_responses', as: :task_responses
  # get "tasks/:id/edit", to: ""
  resources :class_groups, except: :index
  get 'classes/:id', to: 'class_groups#index', as: :admin_classes

  # root to: 'home#index'
  get 'home', to: 'home#index'
  # get "turmas", to: 'class_groups#index'
  # get "tarefas", to: 'tasks#index'

  get 'vincular', to: 'person#index'
  get 'respostas', to: 'responses#index'
end
