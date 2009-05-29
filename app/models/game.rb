class Game < ActiveRecord::Base
  has_many :seatings
  has_many :users, :through => :seatings
  belongs_to :owner, :class_name => 'User'

  validates_presence_of :status, :owner_id, :name
  validates_uniqueness_of :name

  named_scope :open_for_registration, :conditions => ['status = ?', 'new']
  named_scope :unfinished, :conditions => ['status <> ?', 'finished']

  before_save :strip_whitespace
  before_create :add_owner_to_game

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

  def in_progress?
    self.status == 'active'
  end
  
  def started?
    self.status != 'new'
  end

  def start!
    self.status = 'active'
    self.current_player = users[rand(users.length)]
    self.save!
  end

  def owner_name
    owner.display_name
  end

  def joinable?
    self.status == 'new' && users.length < max_players
  end

  def add_player(player)
    raise "Unable to join game" unless joinable?
    users << player
    start! if users.length >= self.max_players
  end

  protected
  def add_owner_to_game
    add_player owner
  end

  def strip_whitespace
    self.name.strip!
  end
end
