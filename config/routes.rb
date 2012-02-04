Newsample::Application.routes.draw do
  get "localevents/new"

  get "localevents/edit"

  get "localevents/index"

  get "localevents/show"

  resources :users 
  resources :sessions, :only => [:new, :create, :destroy]
  resources :members
  
  match '/contact', :to => 'pages#about'
  match '/signup',  :to => 'users#new'
  match '/signin',  :to => 'sessions#new'
  match '/signout', :to => 'sessions#destroy' 
  match '/create_member', :to => 'members#new'
  match '/edit_member', :to => 'members#edit'
  match '/list_members', :to => 'members#index'
  match '/add_member', :to => 'members#new'
  
  match '/construction', :to => "pages#construction"
  root :to => 'pages#home'
end

          
