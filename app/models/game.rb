class GameStateNeedsConfirmation < StandardError
end

class Game < ActiveRecord::Base
  has_many :seatings
  has_many :users, :through => :seatings
  belongs_to :game_state
  belongs_to :owner, :class_name => 'User'

  validates_presence_of :status, :owner_id, :name
  validates_uniqueness_of :name

  named_scope :open_for_registration, :conditions => ['status = ?', 'new']
  named_scope :unfinished, :conditions => ['status <> ?', 'finished']

  before_save :strip_whitespace
  before_create :add_owner_to_game

  attr_writer :game_instance

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
    raise "Cannot have current player without having a started game" if self.status == 'new'
    if game_state && game_state.requires_confirmation?
      game_state.confirmer
    else
      seatings.find_by_user_id(game_instance.current_player_identifier).user
    end
  end

  def in_progress?
    self.status == 'active'
  end

  def started?
    self.status != 'new'
  end

  def start!
    self.status = 'active'
    self.current_player = ordered_users.first
    @game_instance = Dieselisation::GameInstance.new(Dieselisation::Game18AL, ordered_users.map(&:id))
    persist!
    save!
  end

  def start_without_shuffle!
    self.status = 'active'
    self.current_player = ordered_users.first
    @game_instance = Dieselisation::GameInstance.new(Dieselisation::Game18AL, ordered_users.map(&:id), :shuffle_players => false)
    persist!
    save!
  end

  def ordered_users
    seatings.sort_by(&:id).reverse.map(&:user)
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

  def lookup_player(username)
    user_id = users.find_by_username(username).id
    game_instance.players.detect { |x| x.identifier == user_id }
  end

  def game_instance
    @game_instance ||= (game_state && game_state.game_instance)
  end

  def requires_confirmation?
    game_state.requires_confirmation?
  end

  def persist!
    self.game_state = GameState.create!(:game_instance => game_instance, :active_player => current_player, :previous => game_state)
    self.save!
  end

  def confirm!
    game_state.confirm!
  end

  def act(options)
    raise GameStateNeedsConfirmation.new if requires_confirmation?
    @game_instance.act(options)
  end

  protected
  def add_owner_to_game
    add_player owner
  end

  def strip_whitespace
    self.name.strip!
  end
end
