Newsample::Application.routes.draw do
  get "resources/index"

  get "resources/new"

  get "resources/create"

  get "resources/edit"

  get "resources/update"

  get "resources/destroy"

  resources :users 
  resources :sessions, :only => [:new, :create, :destroy]
  resources :members
  resources :localevents
  resources :resources
  
  match '/signup',  :to => 'users#new'
  match '/signin',  :to => 'sessions#new'
  match '/signout', :to => 'sessions#destroy' 

  match '/contact', :to => 'pages#about'
  
  match '/create_member', :to => 'members#new'
  match '/edit_member', :to => 'members#edit'
  match '/list_members', :to => 'members#index'
  match '/add_member', :to => 'members#new'
  
  match '/add_event', :to => 'localevents#new'
  match '/show_event', :to => 'localevents#show'
  match '/list_events', :to => 'localevents#index'
  match '/edit_event', :to => 'localevents#edit'

  match '/add_resource', :to => 'localevents#new'
  match '/list_resource', :to => 'localevents#index'
  match '/edit_resource', :to => 'localevents#edit'
  
  match '/admin', :to => 'pages#admin'
  match '/construction', :to => "pages#construction"
  root :to => 'pages#home'
end

          
