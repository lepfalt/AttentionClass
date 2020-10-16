Rails.application.routes.draw do
  root to: 'sessions#new'
  
  get '/login', to: 'sessions#new'
  post '/sessions', to: 'sessions#create'
  delete '/sessions', to: 'sessions#destroy'
  get '/signup', to: 'users#new'

  get 'user/reset_password(/:user_id)', to: 'users#reset_password', as: :reset_password

  resources :users, only: %i[create show new destroy]
  post 'classes/:class_id/associate', to: 'users#update'

  resources :class_groups, except: %i[index edit]
  get 'classes/:id', to: 'class_groups#index', as: :admin_classes
  get 'classes/:id/associate', to: 'class_groups#new_user', as: :new_user_class
  get 'classes/:id/users', to: 'class_groups#index_users', as: :users_class

  resources :responses, except: %i[index destroy]
  get 'responses/user/:user_id', to: 'responses#index', as: :responses_board
  delete 'responses/:id', to: 'responses#destroy'
  get 'responses/:id/grade', to: 'responses#show_grade', as: :view_grade

  resources :tasks, except: %i[index destroy]
  get 'tasks/user/:user_id', to: 'tasks#index', as: :tasks_board
  get 'task/:id/responses', to: 'tasks#index_responses', as: :task_responses
  get 'task/response/:id', to: 'tasks#show_response', as: :task_response
  delete 'tasks/:id', to: 'tasks#destroy'
  delete 'task/:id', to: 'tasks#cancel', as: :cancel_task
  delete 'tasks/ajusted/:id', to: 'tasks#remove_ajusted', as: :remove_ajusted
end
