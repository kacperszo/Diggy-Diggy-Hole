extends Camera2D
class_name CellCamera
signal cell_changed(new_cell: Vector2i)

@export var player: Player

var _previous_cell: Vector2i = Vector2i.MAX

func _ready() -> void:
	limit_left = -100000
	limit_top = -100000
	limit_right = 100000
	limit_bottom = 100000

func _process(delta: float) -> void:
	update_position()

func update_position() -> void:
	if not player:
		return
	
	var size: Vector2 = Vector2(get_viewport_rect().size) / zoom
	
	# Poprawne obliczenie current_cell z obsługą wartości ujemnych
	var current_cell: Vector2i = Vector2i(
		floorf(player.global_position.x / size.x),
		floorf(player.global_position.y / size.y)
	)
	
	# Sprawdź czy cell się zmienił
	if current_cell != _previous_cell:
		_previous_cell = current_cell
		cell_changed.emit(current_cell)
		print_debug("Cell changed to: ", current_cell)
	
	global_position = Vector2(current_cell) * size
