Event.observe(window, 'load', function() {
		M.initialize();
		MapManager.initialize();
		Dataset.load();
});

M = {				// measurements
  s: 60,
  lineWidth: 8,
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
  tilesPerRow: 8,
  initialize: function()
  {
    this.map = $('map');
  },
  currentTilePosition: function()
  {
    var currentIdx = this.tiles.length;
    var column = currentIdx % this.tilesPerRow;
    var row = Math.floor(currentIdx / this.tilesPerRow);
    var offset = (row % 2 == 0) ? M.width / 2 : 0;

    return { position: 'absolute',
	     top: '' + Math.round(row * M.bv) +'px',
	     left: '' + (Math.round(column * M.width) + offset) +'px'
	   };
  },
  addTile: function(tileData, layRotation)
  {
    var tile = document.createElement('canvas');
    if (typeof(G_vmlCanvasManager) != "undefined")
      G_vmlCanvasManager.initElement(tile);
    tile.setAttribute('width', 200);
    tile.setAttribute('height', 200);
    tile.setStyle(this.currentTilePosition());
    this.drawTile(tile, tileData, layRotation);
    this.map.appendChild(tile);
    this.tiles[this.tiles.length] = tile;
  },
  drawTile: function(tileNode, tileData, layRotation)
  {
    var ctx = tileNode.getContext("2d");
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
    ctx.translate(M.width / 2.0, M.height / 2.0);
    ctx.save();
    tileData.segments.each(function(segment)
      {
	if(segment.type == 'wide') MapManager.drawWideTurn(ctx, segment.side + layRotation, segment.town);
	else if(segment.type == 'tight') MapManager.drawTightTurn(ctx, segment.side + layRotation, segment.town);
	else if(segment.type == 'straight') MapManager.drawStraight(ctx, segment.side + layRotation, segment.town);
      });
  },
  drawTightTurn: function(ctx, side, town)
  {
    this.strokeWithAngle(ctx, side - 2, function()
      {
	ctx.arc(0, M.height / 2, M.h, Math.PI * 11 /6.0, Math.PI * 7/ 6.0 , true);
      });
    if(town)
    this.strokeWithAngle(ctx, side - 2, function()
      {
	ctx.moveTo(0, M.height / 4 + 9);
	ctx.lineTo(0, M.height / 4 - 7);
      });
  },
  drawWideTurn: function(ctx, side, town)
  {
    this.strokeWithAngle(ctx, side, function()
      {
	ctx.arc(M.width, 0, M.s * 1.5, Math.PI * 7/6.0, Math.PI * 5 / 6.0 , true);
      });
    if(town)
    this.strokeWithAngle(ctx, side, function()
      {
	ctx.moveTo(M.width / 4 - 4, 0);
	ctx.lineTo(M.width / 4 - 20, 0);
      });

  },
  drawStraight: function(ctx, side, town)
  {
    this.strokeWithAngle(ctx, side - 1, function()
      {
	ctx.moveTo(M.width / 2, 0);
	ctx.lineTo(0 - M.width / 2, 0);
      });
  },
  strokeWithAngle: function(ctx, side, func)
  {
    ctx.rotate(Math.PI / 3.0 * side);
    ctx.lineWidth = M.lineWidth;
    ctx.beginPath();
    func();
    ctx.stroke();
    ctx.restore();
  }
};

Dataset = {
  load: function()
  {
    var myTiles = $A(tiles).compact();
    for(i = 0; i < 99; i++)
      {
	MapManager.addTile(myTiles[Math.floor(Math.random() * myTiles.length)], Math.floor(Math.random() * 6));
     }
  }
};