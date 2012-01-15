require File.expand_path(File.join(Rails.root, 'lib', 'dieselisation'))

class InvalidGameState < StandardError; end
class GameStateNeedsConfirmation < StandardError; end
class PlayerNotFound < StandardError; end

class Game < ActiveRecord::Base
  has_many :seatings
  has_many :users, :through => :seatings
  belongs_to :game_state
  belongs_to :owner, :class_name => 'User'

  validates_presence_of :status, :owner_id, :name
  validates_uniqueness_of :name

  scope :open_for_registration, :conditions => ['status = ?', 'new']
  scope :unfinished, :conditions => ['status <> ?', 'finished']

  before_save :strip_whitespace
  before_create :add_owner_to_game

  def current_player=(player)
    new_seating = seatings.find_by_user_id(player.id)
    old_seating = seatings.find_by_active(true)
    raise PlayerNotFound.new unless new_seating
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
    raise InvalidGameState.new("Cannot have current player without having a started game") if self.status == 'new'
    if game_state && game_state.requires_confirmation?
      game_state.confirmer
    else
      game_state.active_player
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
    gs = GameState.create!({ :game => self })
    gs.update_active_player
    self.current_player = gs.active_player
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
    raise InvalidGameState.new("Unable to join game") unless joinable?
    users << player
    start! if users.length >= self.max_players
  end

  def lookup_player(username)
    user_id = users.find_by_username(username).id
    game_instance.players.detect { |x| x.identifier == user_id }
  end

  def game_instance
    @game_instance ||= game_state && game_state.game_instance
  end

  def requires_confirmation?
    game_state.requires_confirmation?
  end

  def confirm!
    game_state.confirm!
  end

  def act(options)
    raise GameStateNeedsConfirmation.new if requires_confirmation?
    self.game_state = game_state.act(options)
  end

  def rollback(game_state)
    self.game_state = game_state
    save!
  end

  protected
  def add_owner_to_game
    add_player owner
  end

  def strip_whitespace
    self.name.strip!
  end
end
