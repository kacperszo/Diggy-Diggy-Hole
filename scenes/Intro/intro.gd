extends Node2D



func _on_skip_button_pressed() -> void:

	var new_scene = load("res://scenes/Menu/Menu.tscn") as PackedScene
	if new_scene:
		get_tree().change_scene_to_packed(new_scene)
	else:
		print("Failed to load scene")


func _on_video_stream_player_finished() -> void:
	var new_scene = load("res://scenes/Menu/Menu.tscn") as PackedScene
	if new_scene:
		get_tree().change_scene_to_packed(new_scene)
	else:
		print("Failed to load scene")
