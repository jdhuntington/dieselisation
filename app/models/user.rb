class User < ActiveRecord::Base
  has_many :seatings
  has_many :games, :through => :seatings

  def current_games
    games.find(:all, :conditions => "status = 'waiting' OR status = 'active'")
  end
end
