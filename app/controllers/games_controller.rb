class GamesController < ApplicationController

  before_filter :current_user

  def index
    @games = Game.unfinished
  end
  
  def new
    @game = Game.new
  end

  def create
    game = Game.create!(params[:game].merge({ :status => 'new'}))
    flash[:notice] = 'Game created successfully.'
    redirect_to(game)
  end

  def show
    @game = Game.find params[:id]
  end
end
