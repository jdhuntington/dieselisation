ActionController::Routing::Routes.draw do |map|
  map.resource :session
  map.resource :dashboard
  map.create_session_remotely 'session/create_remote', :controller => 'sessions', :action => 'create_remote'
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
