class_name TileStats
extends Resource

@export var moldiness = 0;
@export var mold_lock = false;
@export var passage_left = false;
@export var passage_rigth = false;
@export var passage_up = false;
@export var passage_down = false;
@export var is_runic = false;
@export var mountain_heart = false;

@export var tile_map_pattern : TileMapPattern;

enum TerrainType {ROCKY, MOLD_STAGE_1, MOLD_STAGE_2, MOLDED}

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
