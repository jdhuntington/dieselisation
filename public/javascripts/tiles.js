var colors = {
  'yellow': "#ffff00",
  'empty': '#ccffcc',
  'red': '#ff2222'
};

var tiles = [];

tiles[997] = { color: 'red', city: 'yes' };
tiles[998] = { color: 'empty', city: 'yes' };
tiles[999] = { color: 'empty' };
tiles[3] = { color: 'yellow', segments: [{ type: 'tight', side: 0, town: true }] };
tiles[7] = { color: 'yellow', segments: [{ type: 'tight', side: 0 }] };
tiles[8] = { color: 'yellow', segments: [{ type: 'wide', side: 0 }] };
tiles[9] = { color: 'yellow', segments: [{ type: 'straight', side: 0 }] };
tiles[58] = { color: 'yellow', segments: [{ type: 'wide', side: 0, town: true }] };

