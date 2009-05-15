class DashboardsController < ApplicationController

  before_filter :current_user

  def show
    @current_games = current_user.current_games
  end
end
