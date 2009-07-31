Given /^there is a game with (\w+), (\w+), (\w+), and (\w+)$/ do |player1, player2, player3, player4|
  player_names = [player1, player2, player3, player4]
  players = player_names.collect { |player_name| User.create!(:username => player_name)}
  @current_game = Game.create!(:owner => players.shift, :name => 'just a game', :status => 'new')
  players.each{ |p| @current_game.add_player(p) }
end

Given /^the game has started$/ do
  @current_game.start!
end

Given /^the player order is (\w+), (\w+), (\w+), and (\w+)$/ do |player1, player2, player3, player4|
  player_names = [player1, player2, player3, player4]
  players = player_names.collect{ |n| User.find_by_username n }
  @current_game.game_instance.players = players.collect do |player|
    @current_game.game_instance.players.detect { |diesel_player| diesel_player.identifier == player.id }
  end
  @current_game.persist!
end

When /^I am logged in as (\w+)$/ do |name|
  @current_player = User.find_by_username name
  Given "I am on the login_as for #{name}"
end

When /^I navigate to the current game's play interface$/ do # '
  visit play_game_path(@current_game)
end

Then /^I should see that it is my turn$/ do
  get_element_via_selector("#current-player").inner_html.should == @current_player.display_name
end

Then /^I should see the option to buy the "([^\"]*)" for (\d+)$/ do |name, price|
  assert get_action_buttons_text.detect { |button| button.index(name) }
end

When /^I choose to buy the "([^\"]*)"$/ do |arg1|
  button = get_action_buttons.detect { |button| button.css("span").inner_html.index(arg1) }
  p button
#  click_link button.css('a').id
end
