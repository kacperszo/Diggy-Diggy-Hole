extends ColorRect


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible=false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_level_manager_runic_fire_count_incresed(new_runic_fire_count: int) -> void:
	visible = true
