extends Node2D

@export var mountain_height_chunk = 10;
@export var mountain_width_chunk = 20;

const TILES_WIDTH_PER_CHUNK = 4;
const TILES_HEIGHT_PER_CHUNK = 3;

var map_states = [];

func _on_ready():
	for x in range(mountain_width_chunk * TILES_WIDTH_PER_CHUNK):
		var row = [];
		for y in range(mountain_height_chunk * TILES_HEIGHT_PER_CHUNK):
			row.append(TileStats.new())
		map_states.append(row);

func update_tile(x:int, y:int, new_value:TileStats):
	map_states[x][y] = new_value	;
