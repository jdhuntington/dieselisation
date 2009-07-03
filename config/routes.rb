ActionController::Routing::Routes.draw do |map|
  map.resources :games, :member => { :act => :put, :join => :put, :start => :put, :play => :get }
  map.resource :session
  map.resource :dashboard
  map.resource :account
  map.create_session_remotely 'session/create_remote', :controller => 'sessions', :action => 'create_remote'
  map.login_as 'session/login_as/:username', :controller => 'sessions', :action => 'login_as'
  map.root :controller => 'dashboards', :action => 'show'
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
