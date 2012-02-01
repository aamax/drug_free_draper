Newsample::Application.routes.draw do
  resources :users 
  resources :sessions, :only => [:new, :create, :destroy]
  resources :members
  
  match '/about', :to => 'pages#about'
  match '/signup',  :to => 'users#new'
  match '/signin',  :to => 'sessions#new'
  match '/signout', :to => 'sessions#destroy' 
  match '/create_member', :to => 'members#new'
  match '/edit_member', :to => 'members#edit'
  match '/list_members', :to => 'members#index'
  
  match '/construction', :to => "pages#construction"
  root :to => 'pages#home'
end

          
