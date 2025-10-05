extends Node2D



func _on_skip_button_pressed() -> void:
	print("Skip button pressed")
	
	var new_scene = load("res://scenes/Menu/Menu.tscn") as PackedScene
	if new_scene:
		print("Scene loaded successfully")
		get_tree().change_scene_to_packed(new_scene)
	else:
		print("Failed to load scene")
