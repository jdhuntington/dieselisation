class User < ActiveRecord::Base

  include Clearance::User

  has_many :seatings
  has_many :games, :through => :seatings

  def current_games
    games.find(:all, :conditions => "status = 'new' OR status = 'active'")
  end

  def unstarted_games
    games.find(:all, :conditions => "status = 'new'")
  end

  def finished_games
    games.find(:all, :conditions => "status = 'finished'")
  end

  def active_games
    games.find(:all, :conditions => "status = 'active'")
  end

  def active_games_waiting_on_me
    games.find(:all, :conditions => "status = 'active'").select do |game|
      game.current_player == self
    end
  end

  def active_games_not_waiting_on_me
    active_games - active_games_waiting_on_me
  end

  def display_name
    if self.actual_name && !self.actual_name.empty?
      self.actual_name
    else
      self.username
    end
  end

  def in_game?(game)
    games.include?(game)
  end

  def current_games_preferred_list
    active_games_waiting_on_me + active_games_not_waiting_on_me + unstarted_games + finished_games
  end
end
