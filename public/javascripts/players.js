Event.observe(window, 'load', function() {
		P.display();
});
var players = $A();

var Player = makeClass();
Player.prototype.init = function(player)
{
  this.identifier = '' + player.identifier;
  this.balance = player.balance;
  this.assets = player.assets;
};
Player.prototype.name = function()
{
  return usersPlayers[this.identifier];
};
Player.prototype.toHTML = function()
{
  var retval = $(document.createElement('div'));
  retval.addClassName('player');
  retval.id = "player_" + this.identifier;
  retval.innerHTML = "<strong>" + this.name() + "</strong><ul>"  // TODO escape output
    + "<li><strong>Balance:</strong>" + this.balance + "</li>"
    + "</ul>";
  return retval;
};

var P = {
  display: function()
  {
    $A(playersJson).each(function(x){ players.push(Player(x)); });
    players.each(function(player) {
		   $("players").insert(player.toHTML());
		 });
  }
};