require File.expand_path(File.dirname(__FILE__) + '/map_parser')
require 'nokogiri'

module Dieselisation
  class Game18AL

    def starting_cash(num_players)
      player_rows = xml('Game.xml').css('Component[name=PlayerManager] Players').to_a
      config = player_rows.detect{ |x| x['number'].to_i == num_players }
      raise ArgumentError.new("Can't find config for #{num_players} players.") unless config
      config['cash'].to_i
    end

    def private_companies
      companies = xml('CompanyManager.xml').css('Company[type=Private]').to_a
      privates = companies.map do |company|
        {
          :name     => company['name'],
          :par      => company['basePrice'].to_i,
          :revenue  => company['revenue'].to_i,
          :special  => 'SPECIAL-FIXME',
          :nickname => company['name'].gsub(/\s*/, '').gsub(/&/,'').downcase
        }
      end
    end

    def bank_size
     xml('Game.xml').css('Bank').first['amount'].to_i 
    end
    
    private
    # TODO memoize
    def xml(filename)
      Nokogiri::XML(File.read(File.join(File.dirname(__FILE__), '18AL', filename)))
    end
  end
end
