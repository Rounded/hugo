Hugo::Application.routes.draw do
  resources :users

  resources :messages
  root :to => 'users#new'



end
