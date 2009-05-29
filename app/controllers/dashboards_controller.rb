class DashboardsController < ApplicationController

  before_filter :current_user

  def show
    @games = current_user.current_games_preferred_list
  end
end
