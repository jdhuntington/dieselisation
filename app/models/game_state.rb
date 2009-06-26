require 'dieselisation'

class GameState < ActiveRecord::Base
  belongs_to :game
  attr_writer :game_instance

  before_save :marshal_data

  def marshal_data
    self.game_state = Marshal.dump(@game_instance)
  end

  def game_instance
    @game_instance ||= Marshal.load(self.game_state)
  end
end
