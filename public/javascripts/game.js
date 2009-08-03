var Utils = {
  watchTogglers: function(){
    $$('.player .toggler input').each(
      function(element){
	element.observe('click',
	  function(e){
	    var target = $(e.findElement('div').parentNode);
	    target.toggleClassName('expanded');
	    target.toggleClassName('collapsed');
	  });
      });
  }
};

Event.observe(window, 'load', function() {
		Utils.watchTogglers();
});