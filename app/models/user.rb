class User < ActiveRecord::Base
  has_many :seatings
  has_many :games, :through => :seatings

  def current_games
    games.find(:all, :conditions => "status = 'new' OR status = 'active'")
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
end
