Event.observe(window, 'load', function() {
		M.initialize();
		MapManager.initialize();
		MapManager.addTile();
});

M = {				// measurements
  s: 60,
  initialize: function()
  {
    this.h = Math.sin(Math.PI * 1/6.0) * this.s;
    this.r = Math.cos(Math.PI * 1/6.0) * this.s;
    this.height = this.s + (2 * this.h);
    this.width = 2 * this.r;
    this.bv = this.s + this.h;
  }
};

MapManager = {
  tiles: $A(),
  initialize: function()
  {
    this.map = $('map');
  },
  addTile: function()
  {
    var tile = document.createElement('canvas');

    tile.setAttribute('width', 200);
    tile.setAttribute('height', 200);
    tile.setStyle({
		    position: 'absolute',
		    top: '90px',
		    left: '390px'
		  });
    this.drawTile(tile);
    this.map.appendChild(tile);
    this.tiles[this.tiles.length] = tile;
  },
  drawTile: function(tile)
  {
    var ctx = tile.getContext("2d");
    ctx.fillStyle = '#ffff00';
    ctx.strokeStyle = '#222222';
    ctx.beginPath();
    ctx.moveTo(M.r, 0);
    ctx.lineTo(M.width, M.h);
    ctx.lineTo(M.width, M.bv);
    ctx.lineTo(M.r, M.height);
    ctx.lineTo(0, M.bv);
    ctx.lineTo(0, M.h);
    ctx.lineTo(M.r, 0);
    ctx.fill();
    ctx.stroke();
    ctx.closePath();

    ctx.lineWidth = 7;
    ctx.beginPath();
    // ctx.arc(M.width, M.h, M.h, Math.PI * 1/6.0, Math.PI / 2.0, true);
    ctx.arc(M.width, M.h, M.h, Math.PI * 7/6.0, Math.PI / 2.0 , true);
    ctx.stroke();
  }
};

