class User < ActiveRecord::Base
  has_many :seatings
  has_many :games, :through => :seatings

  def current_games
    games.find(:all, :conditions => "status = 'new' OR status = 'active'")
  end

  def display_name
    self.actual_name || self.username
  end

  def in_game?(game)
    games.include?(game)
  end
end
