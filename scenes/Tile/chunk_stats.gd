class_name ChunkStats
extends Resource

var tiles = [];

const TILES_WIDTH_PER_CHUNK = 4;
const TILES_HEIGHT_PER_CHUNK = 3;

@export var moldiness = 0;
@export var is_runic = 0;
@export var mold_lock = false;

@export var x_cord = 0;
@export var y_cord = 0;
enum TerrainType {ROCKY, MOLD_STAGE_1, MOLD_STAGE_2, MOLDED}

func update(x:int, y:int, new_value: TileStats):
	tiles[x][y] = new_value

func passage_up_index():
	for x in range(TILES_WIDTH_PER_CHUNK):
		if tiles[x][0]:
			return x;
	return null;
	
func passage_down_index():
	for x in range(TILES_WIDTH_PER_CHUNK):
		if tiles[x][2]:
			return x;
	return null;
	
func passage_left():
	return tiles[1][0]
	
func passage_right():
	print(tiles)
	return tiles[1][3]
	
func _init(t):
	tiles = t
	
func get_type():
	if moldiness < 25:
		return TerrainType.ROCKY
	elif moldiness < 50:
		return TerrainType.MOLD_STAGE_1
	elif moldiness < 75:
		return TerrainType.MOLD_STAGE_2
	else:
		return TerrainType.MOLDED
		
func increase_moldiness(value:int):
	if not mold_lock:
		moldiness += value;
func draw(tile_map: TileMapLayer):
	# narysowac podlege
	tile_map.set_cell(Vector2(4*x_cord, 3*y_cord), 5, Vector2i(0,0))
	tile_map.set_cell(Vector2(4*x_cord+1, 3*y_cord), 5, Vector2i(0,0))
	tile_map.set_cell(Vector2(4*x_cord+2, 3*y_cord), 5, Vector2i(0,0))
	tile_map.set_cell(Vector2(4*x_cord+3, 3*y_cord), 5, Vector2i(0,0))
	# narusowac drabine
	
	# narysowac sufit
