extends Node2D

@export var mountain_height_chunk = 10;
@export var mountain_width_chunk = 10;

const TILES_WIDTH_PER_CHUNK = 4;
const TILES_HEIGHT_PER_CHUNK = 3;

var chunk_states = [];

func _ready():
	for x in range(mountain_width_chunk):
		var row = [];
		for y in range(mountain_height_chunk):
			row.append(null)
		chunk_states.append(row);
		
	#chunk_states[2][2]=ChunkStats.new()
	#chunk_states[2][2].x_cord = 2
	#chunk_states[2][2].y_cord = 2
	#chunk_states[2][2].moldiness = 1
	#chunk_states[6][6]=ChunkStats.new()
	#chunk_states[6][6].moldiness = 1
	#chunk_states[6][6].x_cord = 6
	#chunk_states[6][6].y_cord = 6
		#
	#for i in range(50):
		#increase_growth()
		#print_matrix()

#func print_matrix() -> void:
	#for y in range(mountain_height_chunk):
		#var line := ""
		#for x in range(mountain_width_chunk):
			#var chunk: ChunkStats = chunk_states[x][y]
			#if chunk == null:
				#line += "0 "
			#else:
				#line += str(chunk.moldiness) + " "
		#print(line)
	#print("\n")  # odstęp między iteracjami

func update_tile(x:int, y:int, new_value:ChunkStats):
	chunk_states[x][y] = new_value;
	
func choose_neighbour(x,y) -> void:
	var neighbours: Array[ChunkStats] = []
	
	var directions := [
		Vector2i(-1, 0),
		Vector2i(0, -1),
		Vector2i(0, 1),
		Vector2i(1, 0)
	]
	for dir in directions:
		var nx:int = x + dir.x
		var ny:int = y+ dir.y
		if nx >= 0 and nx < 10 and ny >= 0 and ny < 10:
			var neighbour: ChunkStats = chunk_states[ny][nx]
			if neighbour == null:
				neighbour = ChunkStats.new()
				neighbour.x_cord=nx
				neighbour.y_cord = ny
				neighbours.append(neighbour)
			elif neighbour.moldiness == 0:
				neighbours.append(neighbour)
				
	if neighbours.size() > 0:
		var chosen: ChunkStats = neighbours.pick_random()
		chosen.moldiness = 1
		chunk_states[chosen.y_cord][chosen.x_cord] = chosen
		chunk_states[y][x].children.append(chosen)
		
func has_neighbour(chunk: ChunkStats) -> bool:
	var x:int = chunk.x_cord
	var y:int = chunk.y_cord
	var directions := [
		Vector2i(-1, 0),
		Vector2i(0, -1),
		Vector2i(0, 1),
		Vector2i(1, 0)
	]

	for dir in directions:
		var nx:int = x + dir.x
		var ny:int = y + dir.y
		if nx >= 0 and nx < mountain_width_chunk and ny >= 0 and ny < mountain_height_chunk:
			var neighbour: ChunkStats = chunk_states[ny][nx]
			if neighbour==null or neighbour.moldiness == 0:
				return true

	return false
	
func count_active_neighbours(chunk: ChunkStats) -> int:
	var x: int = chunk.x_cord
	var y: int = chunk.y_cord
	var directions := [
		Vector2i(-1, 0),
		Vector2i(0, -1),
		Vector2i(0, 1),
		Vector2i(1, 0)
	]

	var count := 0
	for dir in directions:
		var nx : int = x + dir.x
		var ny : int = y + dir.y
		if nx >= 0 and nx < mountain_width_chunk and ny >= 0 and ny < mountain_height_chunk:
			var neighbour: ChunkStats = chunk_states[ny][nx]
			if neighbour!=null and neighbour.moldiness > 0:
				count += 1

	return count

func increase_growth() -> void:
	var weighted_pool: Array[ChunkStats] = []

	for row in range(mountain_height_chunk):
		for column in range(mountain_width_chunk):
			var chunk: ChunkStats = chunk_states[column][row]
			if chunk!=null and chunk.moldiness > 0:
				if chunk.moldiness == 3 and not has_neighbour(chunk):
					continue

				# --- liczba aktywnych sąsiadów ---
				var neighbours_active: int = count_active_neighbours(chunk)

				# --- bazowa waga zależna od wartości chunka ---
				var base_weight: float
				match chunk.moldiness:
					3:
						base_weight = 30000.0
					2:
						base_weight = 20000.0
					1:
						base_weight = 10000.0
					_:
						base_weight = 60000.0

				# --- zmodyfikuj wagę na podstawie liczby aktywnych sąsiadów ---
				# Każdy aktywny sąsiad zmniejsza wagę o 25%
				var final_weight: float = max(1.0, base_weight * pow(0.1, neighbours_active))
				for i in range(final_weight):
					weighted_pool.append(chunk)

	if weighted_pool.is_empty():
		return # nic do zwiększania

	# --- losowy wybór chunka z wagami ---
	var chosen_chunk: ChunkStats = weighted_pool.pick_random()
	if chosen_chunk.moldiness < 3:
		chosen_chunk.moldiness += 1
	else:
		choose_neighbour(chosen_chunk.x_cord, chosen_chunk.y_cord)
		
