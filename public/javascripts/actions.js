Event.observe(window, 'load', function() {
		A.display();
});
var actions = $A();

var Action = makeClass();
Action.prototype.init = function(identifier, details)
{
  this.identifier = identifier;
  if(!details['private'])return;
  this.friendly_name = details['private'].name;
  this.cost = details['private'].par;
    // this.assets = player.assets;
};
Action.prototype.toHTML = function()
{
  var retval = $(document.createElement('div'));
  retval.addClassName('action');
  retval.id = "action_" + this.identifier;
  retval.innerHTML = '<a href="act?action=' + this.identifier + '" class="custom-button"><span>' + this.friendly_name + '($' + this.cost + ')</span></a>';
  console.log(retval);
  return retval;
};

var A = {
  display: function()
  {
    $H(actionsJson).each(function(x){ actions.push(Action(x[0], x[1])); });
    actions.each(function(action) {
		   $("actions").insert(action.toHTML());
		 });
  }
};