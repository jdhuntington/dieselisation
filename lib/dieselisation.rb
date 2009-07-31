module Dieselisation
end
current = File.dirname(__FILE__)
%w{ bank base board cell certificate company game_instance map_parser player private util game_18ga action }.each do |f|
  require File.expand_path(File.join(current, 'dieselisation', f))
end
