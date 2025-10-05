extends Node2D

@export var mountain_height_chunk = 50;
@export var mountain_width_chunk = 50;
@export var tile_map: TileMapLayer
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

func safe_access_chunks(x, y):
	if x >= 0 and x < mountain_width_chunk and y >= 0  and y < mountain_height_chunk:
		return chunk_states[x][y]
	else:
		return null

func mark_chunks_to_regenerate(current_chunk_x, current_chunk_y):
	var directions := [
		Vector2i(-2, 0),
		Vector2i(0, -2),
		Vector2i(0, 2),
		Vector2i(2, 0),
		Vector2i(1, 1),
		Vector2i(1, -1),
		Vector2i(-1, -1),
		Vector2i(-1, 1)
	]
	
	for i in range(directions.size()):
		var x = directions[i][0] + current_chunk_x
		var y = directions[i][1] + current_chunk_y
		
		var optional_chunk = safe_access_chunks(x, y)
		if optional_chunk == null:
			continue
		
		optional_chunk.should_be_regenerated = true;
		

func _on_camera_2d_cell_changed(new_cell: Vector2i) -> void:
	var chunk_left: ChunkStats = null
	var chunk_right: ChunkStats = null
	var chunk_up: ChunkStats = null
	var chunk_down: ChunkStats = null

	var col = new_cell[0]
	var row = new_cell[1]

	if chunk_states[row][col] != null and not chunk_states[row][col].should_be_regenerated:
		return

	if col - 1 >= 0:
		chunk_left = chunk_states[row][col-1]
	if col + 1 < mountain_width_chunk:
		chunk_right = chunk_states[row][col+1]
	if row - 1 >= 0:
		chunk_up = chunk_states[row-1][col]
	if row + 1 >= mountain_height_chunk:
		chunk_down = chunk_states[row+1][col]

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
		print('chunk up', chunk_up.passage_down_index())
		if chunk_up.passage_down_index() != null:
			tiles[0][chunk_up.passage_down_index()] = 1
	else:
		if [true, false].pick_random():
			tiles[0][randi() % (TILES_WIDTH_PER_CHUNK - 1)] = 1

	if chunk_down != null:
		if chunk_down.passage_up_index() != null:
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
			if x == 1 && tiles[1][y] == 1 && tiles[0][y] == 1:
				tile.is_ladder = true
			row2.append(tile)
		tiles_stats.append(row2)
		
	var new_chunk = ChunkStats.new()
	new_chunk.tiles = tiles_stats
	new_chunk.x_cord = row
	new_chunk.y_cord = col
	if chunk_states[row][col] != null:
		new_chunk.moldiness = chunk_states[row][col].moldiness
	chunk_states[row][col] = new_chunk
	new_chunk.draw(tile_map)
	
	mark_chunks_to_regenerate(row, col)
