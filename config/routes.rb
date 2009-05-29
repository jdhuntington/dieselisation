ActionController::Routing::Routes.draw do |map|
  map.resources :games, :member => { :join => :put, :start => :put }
  map.resource :session
  map.resource :dashboard
  map.resource :account
  map.create_session_remotely 'session/create_remote', :controller => 'sessions', :action => 'create_remote'
  map.root :controller => 'dashboards', :action => 'show'
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
