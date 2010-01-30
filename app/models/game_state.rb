require 'dieselisation'

class GameState < ActiveRecord::Base
  has_one :game
  belongs_to :active_player, :class_name => 'User'
  belongs_to :previous, :class_name => 'GameState'
  
  attr_writer :game_instance
  before_save :marshal_data

  def game_instance
    @game_instance ||= game_state && Marshal.load(game_state)
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

  private
  def marshal_data
    self.game_state = Marshal.dump(game_instance)
  end
end
