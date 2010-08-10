class ScenariosController < ApplicationController
  def index
    @scenarios = Scenario.all
  end

  def show
    @scenario = Scenario.find(params[:id])
  end

  # non "REST"
  def load
    raise "INTRUDER ALERT!" unless %w{ development cucumber test}.include?(ENV['RAILS_ENV'])
    game_state = GameState.find(params[:gamestate])
    game = Game.find(game_state.game_id)
    session[:user_id] = game_state.active_player_id
    redirect_to play_game_url(game)
  end
end
