require 'dieselisation'

class GameState < ActiveRecord::Base
  belongs_to :game
  belongs_to :active_player, :class_name => 'User'
  belongs_to :previous, :class_name => 'GameState'
  
  attr_writer :game_instance
  before_save :marshal_data

  def game_instance
    @game_instance ||= Marshal.load(self.game_state)
  end

  private
  def marshal_data
    self.game_state = Marshal.dump(@game_instance)
  end
end
