extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_level_manager_fire_count_incresed(new_fire_count: int) -> void:
	text = "🔥  "+str(+new_fire_count)+"/5"
