class Game < ActiveRecord::Base
  has_many :seatings
  has_many :users, :through => :seatings
end
