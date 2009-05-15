class DashboardsController < ApplicationController
  def show
    @current_games = current_user.current_games
  end
end
