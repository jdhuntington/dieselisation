module Dieselisation
  module Game18GA
    MAPFILE = File.expand_path(File.dirname(__FILE__) + '/18GA/map')
    CONFIG = YAML.load_file(File.dirname(__FILE__) + '/18GA/game_18ga.yml')
  end
end
