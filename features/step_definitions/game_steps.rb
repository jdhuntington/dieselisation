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

When /^I navigate to the current game\'s play interface$/ do
  visit play_game_path(@current_game)
end

Then /^I should see that it is my turn$/ do
  get_element_via_selector("#current-player").inner_html.should == @current_player.display_name
end

Then /^I should see that it is (\w+)\'s turn$/ do |arg1|
  get_element_via_selector("#current-player").inner_html.should == arg1
end

When /^I confirm my action$/ do
  click_button "Confirm"
end

Then /^I should see that I have "([^\"]*)" dollars left$/ do |arg1|
  cash_node = get_content_of_selector "#dieselisation_player_#{@current_player.id} .main-stats .cash"
  assert_equal arg1, trim_currency_marker(cash_node)
end

Transform /^player (\w+)$/ do |username|
  User.find_by_username username
end

Then /^(player \w+) should be in posession of "([^\"]*)"$/ do |user, arg2|
  asset_names = get_elements_via_selector("#dieselisation_player_#{user.id} .certificates ul li").map(&:inner_html)
  asset_names.should include(arg2)
end
