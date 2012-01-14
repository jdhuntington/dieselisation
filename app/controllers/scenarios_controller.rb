class ScenariosController < ApplicationController
  def index
    @scenarios = Scenario.all
  end

  def show
    @scenario = Scenario.find(params[:id])
  end


  def load
    if %w{ development test }.include?(Rails.env)
      game_state        = GameState.find(params[:gamestate])
      game              = Game.find(game_state.game_id)
      sign_in User.find(game_state.active_player_id)
      redirect_to play_game_url(game)
    else
      render :text => '404', :status => 404
    end
  end
end
