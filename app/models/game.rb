class Game < ActiveRecord::Base
  has_many :seatings
  has_many :users, :through => :seatings

  validates_presence_of :status

  named_scope :unfinished, :conditions => ['status <> ?', 'finished']

  def current_player=(player)
    new_seating = seatings.find_by_user_id(player.id)
    old_seating = seatings.find_by_active(true)
    raise unless new_seating
    Game.transaction do
      if old_seating
        old_seating.active = false
        old_seating.save!
      end
      new_seating.active = true
      new_seating.save!
    end
  end
  
  def current_player
    seatings.find_by_active(true).user
  end

  def start!
    self.status = 'active'
    self.current_player = users[rand(users.length)]
    self.save!
  end

  def owner_name
    "abc"
  end
end
