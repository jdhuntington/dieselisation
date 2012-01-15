require 'dieselisation'
require 'json'

class GameState < ActiveRecord::Base
  has_one :game
  belongs_to :active_player, :class_name => 'User'
  belongs_to :previous, :class_name => 'GameState'

  def game_instance
    @game_instance ||= if previous
                         raise ArgumentError.new('Expected #action') if action.blank?
                         previous.apply(JSON.parse(action))
                       else
                         eval(game.implementation).new(game.ordered_users.map(&:id), :shuffle_players => false)
                       end
  end

  def act(options)
    apply(options)
    succ = GameState.create!({ :game => game, :previous => self, :action => options.to_json, :active_player => game_instance.current_player })
    game.game_state = succ
    game.save!
    succ
  end

  def apply(options)
    game_instance.act(options)
    game_instance
  end

  def requires_confirmation?
    return false unless previous
    return false if confirmed
    return false if previous.active_player == active_player
    true
  end

  def update_active_player
    update_attribute(:active_player_id, game_instance.current_player_identifier)
  end

  def confirmer
    previous && previous.active_player
  end

  def confirm!
    update_attribute(:confirmed, true)
  end
end
