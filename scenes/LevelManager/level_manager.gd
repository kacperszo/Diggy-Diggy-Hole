extends Node2D

@export var mountain_height_chunk = 10;
@export var mountain_width_chunk = 20;

const TILES_WIDTH_PER_CHUNK = 4;
const TILES_HEIGHT_PER_CHUNK = 3;

var chunk_states = [];

func _on_ready():	
	for x in range(mountain_width_chunk):
		var row = [];
		for y in range(mountain_height_chunk):
			row.append(null)
		chunk_states.append(row);

func update_tile(x:int, y:int, new_value:ChunkStats):
	chunk_states[x][y] = new_value	;
