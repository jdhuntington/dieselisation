class GamesController < ApplicationController

  before_filter :current_user

  def index
    @games = Game.open_for_registration
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
    if !game.joinable?
      flash[:error] = "Sorry, this game has already started or is full."
    else
      game.add_player current_user
    end
  rescue ActiveRecord::RecordInvalid
    flash[:error] = "You've already joined this game."
  ensure
    redirect_to game_url(game)
  end

  def edit
    @game = Game.find params[:id]
  end

  def update
    @game = Game.find(params[:id])
    @game.update_attributes!(params[:game])
    flash[:notice] = 'Game updated successfully.'
    redirect_to(@game)
  rescue ActiveRecord::RecordInvalid
    render :action => 'edit'
  end

  def start
    game = Game.find params[:id]
    if game.owner == current_user
      game.start!
      flash[:notice] = 'Game started.'
    else
      flash[:error] = 'Only the game owner may start the game.'
    end
    redirect_to game_url(game)
  end

  def play
    @game_instance = Dieselisation::GameInstance.new(Dieselisation::Game18GA)
  end
end
