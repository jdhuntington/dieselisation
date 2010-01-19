Factory.sequence(:identifier) { |n| Digest::MD5.hexdigest(n.to_s) }

Factory.define :player, :class => 'user' do |u|
  u.identifier {  Factory.next :identifier }
  u.sequence(:username) { |n| "user-#{n}" }
end

Factory.define :game, :class => 'game' do |g|
  g.association :owner, :factory => :player
  g.sequence(:name) { |n| "game-#{n}" }
  g.status 'new'
end

Factory.define :game_state, :class => 'GameState' do |gs|
  
end

