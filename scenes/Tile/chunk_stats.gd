class_name ChunkStats
extends Resource

@export var tiles = [];
var children: Array[ChunkStats] = [];

const TILES_WIDTH_PER_CHUNK = 4;
const TILES_HEIGHT_PER_CHUNK = 3;

@export var moldiness = 0;
@export var is_runic = 0;
@export var mold_lock = false;
@export var x_cord = 0;
@export var y_cord = 0;

var should_be_regenerated = false;
enum TerrainType {ROCKY, MOLD_STAGE_1, MOLD_STAGE_2, MOLDED, RUNIC}

func update(x:int, y:int, new_value: TileStats):
	tiles[x][y] = new_value

func passage_up_index():
	for y in range(TILES_WIDTH_PER_CHUNK):
		if tiles[0][y].is_ladder:
			return y;
	return null;
	
func passage_down_index():
	for y in range(TILES_WIDTH_PER_CHUNK):
		if tiles[2][y].is_ladder:
			return y;
	return null;

func passage_left():
	return tiles[1][0]

func passage_right():
	return tiles[1][3]
	
func get_type():
	if is_runic:
		return TerrainType.RUNIC
	elif moldiness < 25:
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
	# Serce Gory narysuj

	# Runowy pokoj narysuj
	if is_runic:
		drew_runic_room(tile_map)
	else:
	# Zwykle narysuj pomieszczenie
		draw_regular_room(tile_map)


func drew_runic_room(tile_map: TileMapLayer):
		# narysowac podlege
	if tiles[2][0].is_rock:
		tile_map.set_cell(Vector2(4*y_cord, 3*x_cord), 5, Vector2i(0,0))
	if tiles[2][1].is_rock:
		tile_map.set_cell(Vector2(4*y_cord+1, 3*x_cord), 5, Vector2i(0,0))
	if tiles[2][2].is_rock:
		tile_map.set_cell(Vector2(4*y_cord+2, 3*x_cord), 5, Vector2i(0,0))
	if tiles[2][3].is_rock:
		tile_map.set_cell(Vector2(4*y_cord+3, 3*x_cord), 5, Vector2i(0,0))

	# narusowac drabine
	if tiles[2][0].is_ladder:
		tile_map.set_cell(Vector2(4*y_cord, 3*x_cord), 0, Vector2i(0,0))
	if tiles[2][1].is_ladder:
		tile_map.set_cell(Vector2(4*y_cord+1, 3*x_cord), 0, Vector2i(0,0))
	if tiles[2][2].is_ladder:
		tile_map.set_cell(Vector2(4*y_cord+2, 3*x_cord), 0, Vector2i(0,0))
	if tiles[2][3].is_ladder:
		tile_map.set_cell(Vector2(4*y_cord+3, 3*x_cord), 0, Vector2i(0,0))

	if tiles[0][0].is_ladder:
		tile_map.set_cell(Vector2(4*y_cord, 3*x_cord-2), 0, Vector2i(0,0))
	if tiles[0][1].is_ladder:
		tile_map.set_cell(Vector2(4*y_cord+1, 3*x_cord-2), 0, Vector2i(0,0))
	if tiles[0][2].is_ladder:
		tile_map.set_cell(Vector2(4*y_cord+2, 3*x_cord-2), 0, Vector2i(0,0))
	if tiles[0][3].is_ladder:
		tile_map.set_cell(Vector2(4*y_cord+3, 3*x_cord-2), 0, Vector2i(0,0))

	# narysowac sufit
	if tiles[0][0].is_rock:
		tile_map.set_cell(Vector2(4*y_cord, 3*x_cord-2), 5, Vector2i(0,0), 1)
	if tiles[0][1].is_rock:
		tile_map.set_cell(Vector2(4*y_cord+1, 3*x_cord-2), 5, Vector2i(0,0), 1)
	if tiles[0][2].is_rock:
		tile_map.set_cell(Vector2(4*y_cord+2, 3*x_cord-2), 5, Vector2i(0,0), 1)
	if tiles[0][3].is_rock:
		tile_map.set_cell(Vector2(4*y_cord+3, 3*x_cord-2), 5, Vector2i(0,0), 1)

	#narysowac korytarz
	if tiles[1][0].is_rock:
		tile_map.set_cell(Vector2(4*y_cord, 3*x_cord-1), 5, Vector2i(0,0))
	if tiles[1][1].is_rock:
		tile_map.set_cell(Vector2(4*y_cord+1, 3*x_cord-1), 5, Vector2i(0,0))
	if tiles[1][2].is_rock:
		tile_map.set_cell(Vector2(4*y_cord+2, 3*x_cord-1), 5, Vector2i(0,0))
	if tiles[1][3].is_rock:
		tile_map.set_cell(Vector2(4*y_cord+3, 3*x_cord-1), 5, Vector2i(0,0))


func draw_regular_room(tile_map: TileMapLayer):
	if tiles[2][0].is_rock:
		tile_map.set_cell(Vector2(4*y_cord, 3*x_cord), 5, Vector2i(0,0))
	if tiles[2][1].is_rock:
		tile_map.set_cell(Vector2(4*y_cord+1, 3*x_cord), 5, Vector2i(0,0))
	if tiles[2][2].is_rock:
		tile_map.set_cell(Vector2(4*y_cord+2, 3*x_cord), 5, Vector2i(0,0))
	if tiles[2][3].is_rock:
		tile_map.set_cell(Vector2(4*y_cord+3, 3*x_cord), 5, Vector2i(0,0))
		
	# narusowac drabine
	if tiles[2][0].is_ladder:
		tile_map.set_cell(Vector2(4*y_cord, 3*x_cord), 0, Vector2i(0,0))
	if tiles[2][1].is_ladder:
		tile_map.set_cell(Vector2(4*y_cord+1, 3*x_cord), 0, Vector2i(0,0))
	if tiles[2][2].is_ladder:
		tile_map.set_cell(Vector2(4*y_cord+2, 3*x_cord), 0, Vector2i(0,0))
	if tiles[2][3].is_ladder:
		tile_map.set_cell(Vector2(4*y_cord+3, 3*x_cord), 0, Vector2i(0,0))
		
	if tiles[0][0].is_ladder:
		tile_map.set_cell(Vector2(4*y_cord, 3*x_cord-2), 0, Vector2i(0,0), 1)
	if tiles[0][1].is_ladder:
		tile_map.set_cell(Vector2(4*y_cord+1, 3*x_cord-2), 0, Vector2i(0,0), 1)
	if tiles[0][2].is_ladder:
		tile_map.set_cell(Vector2(4*y_cord+2, 3*x_cord-2), 0, Vector2i(0,0), 1)
	if tiles[0][3].is_ladder:
		tile_map.set_cell(Vector2(4*y_cord+3, 3*x_cord-2), 0, Vector2i(0,0), 1)
	
	# narysowac sufit
	if tiles[0][0].is_rock:
		tile_map.set_cell(Vector2(4*y_cord, 3*x_cord-2), 5, Vector2i(0,0), 1)
	if tiles[0][1].is_rock:
		tile_map.set_cell(Vector2(4*y_cord+1, 3*x_cord-2), 5, Vector2i(0,0), 1)
	if tiles[0][2].is_rock:
		tile_map.set_cell(Vector2(4*y_cord+2, 3*x_cord-2), 5, Vector2i(0,0), 1)
	if tiles[0][3].is_rock:
		tile_map.set_cell(Vector2(4*y_cord+3, 3*x_cord-2), 5, Vector2i(0,0), 1)
		
	#narysowac korytarz
	if tiles[1][0].is_rock:
		tile_map.set_cell(Vector2(4*y_cord, 3*x_cord-1), 5, Vector2i(0,0))
	if tiles[1][1].is_rock:
		tile_map.set_cell(Vector2(4*y_cord+1, 3*x_cord-1), 5, Vector2i(0,0))
	if tiles[1][2].is_rock:
		tile_map.set_cell(Vector2(4*y_cord+2, 3*x_cord-1), 5, Vector2i(0,0))
	if tiles[1][3].is_rock:
		tile_map.set_cell(Vector2(4*y_cord+3, 3*x_cord-1), 5, Vector2i(0,0))

	if tiles[1][0].is_ladder:
		tile_map.set_cell(Vector2(4*y_cord, 3*x_cord-1), 1, Vector2i(0,0))
	if tiles[1][1].is_ladder:
		tile_map.set_cell(Vector2(4*y_cord+1, 3*x_cord-1), 1, Vector2i(0,0))
	if tiles[1][2].is_ladder:
		tile_map.set_cell(Vector2(4*y_cord+2, 3*x_cord-1), 1, Vector2i(0,0))
	if tiles[1][3].is_ladder:
		tile_map.set_cell(Vector2(4*y_cord+3, 3*x_cord-1), 1, Vector2i(0,0))
