Dieselisation::Application.routes.draw do
  resources :games do
    member do
      get 'play'
      post 'act'
      post 'confirm'
      put 'join'
      put 'start'
    end
  end
  
  resource :dashboard
  root :to => 'dashboards#show'
  
  resources :scenarios
  match 'scenario/load' => 'scenarios#load', :as => 'load_scenario'
  
  match 'session/login_as/:username' => 'sessions#login_as', :as => 'login_as'
end
