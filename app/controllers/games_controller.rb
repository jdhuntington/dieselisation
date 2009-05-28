class GamesController < ApplicationController

  before_filter :current_user

  def index
    @games = Game.unfinished
  end
  
  def new
    @game = Game.new(:name => "#{current_user.username}'s game")
  end

  def create
    game = Game.create!(params[:game].merge({ :status => 'new', :owner => current_user}))
    flash[:notice] = 'Game created successfully.'
    redirect_to(game)
  rescue ActiveRecord::RecordInvalid
    @game = Game.new(params[:game].merge({ :status => 'new', :owner => current_user}))
    @game.valid?
    render :action => 'new'
  end

  def show
    @game = Game.find params[:id]
  end

  def join
    game = Game.find params[:id]
    game.users << current_user
  rescue ActiveRecord::RecordInvalid
    flash[:error] = "You've already joined this game."
  ensure
    redirect_to game_url(game)
  end
end
