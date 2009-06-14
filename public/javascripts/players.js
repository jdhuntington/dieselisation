Event.observe(window, 'load', function() {
		P.display();
});
var players = $A();

var Player = makeClass();
Player.prototype.init = function(identifier, json)
{
  this.identifier = identifier;
  this.name = json.name;
  this.balance = json.balance;
  this.seat_order = json.seat_order;
  this.assets = json.assets;
};
Player.prototype.toHTML = function()
{
  var retval = $(document.createElement('div'));
  retval.addClassName('player');
  retval.id = "player_" + this.identifier;
  retval.innerHTML = "<strong>" + this.name + "</strong><ul>"  // TODO escape output
    + "<li><strong>Balance:</strong>" + this.balance + "</li>"
    + "<li><strong>Seat:</strong>" + this.seat_order + "</li>"
    + "</ul>";
  return retval;
};

var P = {
  display: function()
  {
    $H(playersJson).each(function(x){ players.push(Player(x[0],x[1])); });
    players.each(function(player) {
		   $("players").insert(player.toHTML());
		 });
  }
};