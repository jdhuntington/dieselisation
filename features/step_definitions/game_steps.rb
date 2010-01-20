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
  @current_game.game_state.previous = nil # Make sure that we're not going to have confirmation required
  @current_game.game_state.save!
end

When /^I log in as (\w+)$/ do |username|
  @current_player = User.find_by_username username
  Given "I am on the login_as for #{username}"
end

When /^I navigate to the current game's play interface$/ do # '
  visit play_game_path(@current_game)
end

Then /^I should see that it is my turn$/ do
  get_element_via_selector("#current-player").inner_html.should == @current_player.display_name
end

Then /^I should see the option to buy the "([^\"]*)" for (\d+)$/ do |name, price|
  nickname = lookup_private_nickname name
  Then "I should see \"#{price}\" within \"#private-#{nickname} .purchase .par\""
  assert_have_selector "#buy-#{nickname}"
end

When /^I choose to buy the "([^\"]*)"$/ do |arg1|
  within "div.private#private-#{lookup_private_nickname(arg1)}" do |scope|
    scope.click_button "Buy"
  end

end

When /^I confirm my action$/ do
  click_button "Confirm"
end
