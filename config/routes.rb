Rails.application.routes.draw do
  resources :users, only: %i[create show]
  post 'classes/vincular/:class_id', to: 'users#update'

  get '/signup', to: 'users#new'
  get '/login', to: 'sessions#new'
  post '/sessions', to: 'sessions#create'
  delete '/sessions', to: 'sessions#destroy'

  root to: 'sessions#new'

  resources :responses, except: :index
  resources :tasks, except: :index
  get 'tasks/user/:user_id', to: 'tasks#index', as: :tasks_board
  get 'tarefa/respostas/:id', to: 'tasks#index_responses', as: :task_responses
  get 'tarefa/resposta/:id', to: 'tasks#show_response', as: :task_response
  patch 'response/evaluate/:id', to: 'responses#evaluate_response', as: :evaluate_response
  # get "tasks/:id/edit", to: ""
  resources :class_groups, except: :index
  get 'classes/:id', to: 'class_groups#index', as: :admin_classes
  get 'classes/vincular/:id', to: 'class_groups#new_user', as: :new_user_class

  # root to: 'home#index'
  get 'home', to: 'home#index'
  # get "turmas", to: 'class_groups#index'
  # get "tarefas", to: 'tasks#index'

  get 'respostas/user/:user_id', to: 'responses#index', as: :responses_board
end
