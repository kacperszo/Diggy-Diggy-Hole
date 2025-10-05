extends CharacterBody2D
class_name Player
	
@export var move_speed: float = 100.0
@export var climb_speed: float = 150.0
@export var gravity: float = 600.0
@export var objects_layer: TileMapLayer
@export var poisonTolerance: float = 100.0

var on_ladder := false

func _physics_process(delta: float) -> void:
	var move_vector := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	var local_pos := objects_layer.to_local(global_position)
	var tile_pos := objects_layer.local_to_map(local_pos)
	var tile_data := objects_layer.get_cell_tile_data(tile_pos)
	
	on_ladder = false
	if tile_data:
		var is_ladder = tile_data.get_custom_data("ladder")
		if is_ladder:
			on_ladder = true
	
	if on_ladder:
		velocity.x = move_vector.x * move_speed
		velocity.y = move_vector.y * climb_speed
		if move_vector.length() == 0:
			velocity = Vector2.ZERO
	else:
		velocity.x = move_vector.x * move_speed
		if not is_on_floor():
			velocity.y += gravity * delta
		else:
			velocity.y = 0
	
	move_and_slide()


func _on_camera_2d_cell_changed(new_cell: Vector2i) -> void:
	print_debug("Zmiana kamery do: ", new_cell)
