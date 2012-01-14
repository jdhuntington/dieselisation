require 'dieselisation'
require 'json'

class GameState < ActiveRecord::Base
  has_one :game
  belongs_to :active_player, :class_name => 'User'
  belongs_to :previous, :class_name => 'GameState'

  def game_instance
    @game_instance ||= eval(game.implementation).new
  end

  def act(options)
    game_instance.act(options)
    succ = GameState.create!({ :game => game, :previous => self, :action => options.to_json })
    game.game_state = succ
    game.save!
    true
  end

  def requires_confirmation?
    return false unless previous
    return false if confirmed
    return false if previous.active_player == active_player
    true
  end

  def confirmer
    previous && previous.active_player
  end

  def confirm!
    update_attribute(:confirmed, true)
  end
end
