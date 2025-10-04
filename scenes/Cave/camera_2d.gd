extends Camera2D

@export var player: Player

func _ready() -> void:
	update_position()
	
func _process(delta: float) -> void:
	update_position()

func _physics_process(delta: float) -> void:
	update_position()

func update_position() -> void:
	var size: Vector2i = get_viewport_rect().size / zoom
	var current_cell: Vector2i = Vector2i(player.global_position) / Vector2i(size)	
	global_position = current_cell * size
