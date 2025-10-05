extends Node2D

@export var mountain_height_chunk = 10;
@export var mountain_width_chunk = 20;

const TILES_WIDTH_PER_CHUNK = 4;
const TILES_HEIGHT_PER_CHUNK = 3;

var chunk_states = [];

func _ready():
	for a in range(mountain_width_chunk):
		var row = [];
		for b in range(mountain_height_chunk):
			row.append(null)
		chunk_states.append(row);

func update_tile(x: int, y: int, new_value: ChunkStats):
	chunk_states[x][y] = new_value	;

func _on_camera_2d_cell_changed(new_cell: Vector2i) -> void:
	var chunk_left: ChunkStats = null
	var chunk_right: ChunkStats = null
	var chunk_up: ChunkStats = null
	var chunk_down: ChunkStats = null
	
	var col = new_cell[0]
	var row = new_cell[1]
	
	if chunk_states[row][col] != null:
		return
	
	if col - 1 >= 0:
		chunk_left = chunk_states[row][col-1]
	if col + 1 < mountain_width_chunk:
		chunk_right = chunk_states[row][col+1]
	if row + 1 < mountain_height_chunk: 
		chunk_up = chunk_states[row+1][col]
	if new_cell[1]-1 >= 0:
		chunk_down = chunk_states[row-1][col]
		
	var tiles = []
	for x in range(TILES_HEIGHT_PER_CHUNK):
		var row2 = [];
		for y in range(TILES_WIDTH_PER_CHUNK):
			row2.append(0)
		tiles.append(row2);
	
	if chunk_left != null:
		if chunk_left.passage_right():
			tiles[1][0] = 1
	else:
		if [true, false].pick_random():
			tiles[1][0] = 1
	
	if chunk_right != null:
		if chunk_right.passage_left():
			tiles[1][-1] = 1
	else:
		if [true, false].pick_random():
			tiles[1][-1] = 1
	
	if chunk_up != null:
		if chunk_up.passage_down_index():
			tiles[0][chunk_up.passage_down_index()] = 1
	else:
		if [true, false].pick_random():
			tiles[0][randi() % (TILES_WIDTH_PER_CHUNK - 1)] = 1
			
	if chunk_down != null:
		if chunk_down.passage_up_index():
			tiles[2][chunk_up.passage_up_index()] = 1
	else:
		if [true, false].pick_random():
			tiles[2][randi() % (TILES_WIDTH_PER_CHUNK - 1)] = 1
	
	var ones_positions: Array = []
	for x in range(TILES_HEIGHT_PER_CHUNK):
		for y in range(TILES_WIDTH_PER_CHUNK):
			if tiles[x][y] == 1:
				ones_positions.append(y)
				
	if ones_positions.is_empty():
		return  # no ones at all
		
	var leftmost = ones_positions.min()
	var rightmost = ones_positions.max()
	
	for x in range(leftmost, rightmost + 1):
		tiles[1][x] = 1
	
	var tiles_stats = []
	for x in range(TILES_HEIGHT_PER_CHUNK):
		var row2 = [];
		for y in range(TILES_WIDTH_PER_CHUNK):
			var tile = TileStats.new()
			if (x == 0 || x == 2) && tiles[x][y] == 1:
				tile.is_ladder = true
			if tiles[x][y] == 0:
				tile.is_rock = true
			row2.append(tile)
		tiles_stats.append(row2)
	var new_chunk = ChunkStats.new(tiles_stats)
	new_chunk.x_cord = row
	new_chunk.y_cord = col
	chunk_states[row][col] = new_chunk
	
	
