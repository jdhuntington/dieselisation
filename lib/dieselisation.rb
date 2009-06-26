module Dieselisation
end
current = File.dirname(__FILE__)
%w{ bank base board cell certificate company game_instance map_parser player private }.each do |f|
  require File.join(current, 'dieselisation', f)
end
